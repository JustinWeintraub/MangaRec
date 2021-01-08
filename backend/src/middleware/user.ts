import User from "../models/User.js";
import Manga from "../models/Manga.js";
const base = "/user/";
import bcrypt from "bcrypt";
import jwt from "jwt-then";
import helpers from "./helpers.js";
import { Application, Request, Response } from "express";
import pkg from "sequelize";
const { Op } = pkg;

export default function userWare(app: Application) {
  app.get(base + "users", (req, res) =>
    User.findAll().then((result) =>
      res.json(helpers.success({ result: result }))
    )
  );
  app.post(base + "register", (req, res) => {
    // TODO add way more to this
    User.create(req.body)
      .then(() => {
        return res.json(helpers.success());
      })

      .catch(function (e) {
        return res.json(helpers.error(e.helpers.errors[0].message));
      });
  });
  app.post(base + "login", (req, res) => {
    const { username, password } = req.body;
    User.findOne({ where: { username: username } })
      .then(async (user) => {
        if (!user) return res.json(helpers.error("Incorrect username"));
        //TODO move this?
        if (!(await bcrypt.compareSync(password, user["password"])))
          return res.json(helpers.error("Incorrect password"));
        return res.json(
          helpers.success({
            jwt: await jwt.sign(
              {
                username: user["username"],
              },
              process.env.JWTKey,
              {
                expiresIn: "1d",
              }
            ),
          })
        ); //TODO need to implement time limit
      })
      .catch((e) => {
        return res.json(helpers.error(e.message));
      });
  });

  app.post(base + "favoriteManga", helpers.passport, async (req, res) => {
    const { user } = req;
    const { manga } = req.body;
    Manga.findOne({ where: { title: manga } })
      .then((out) => {
        if (out == null) return res.json(helpers.error("Invalid manga."));

        let allManga = user["manga"];
        if (allManga.includes(manga))
          allManga = allManga.filter((item) => item != manga);
        else allManga.push(manga);

        User.update(
          {
            manga: allManga,
          },
          { where: { username: user["username"] } }
        )
          .then(() => {
            return res.json(
              helpers.success({
                manga: allManga,
              })
            );
          })
          .catch((e) => res.json(helpers.error(e.message)));
      })
      .catch(() => {
        return res.json(helpers.error("Invalid manga."));
      });
  });

  app.post(
    base + "getManga",
    helpers.passport,
    (req: Request, res: Response) => {
      res.status(200).json(helpers.success({ manga: req.user["manga"] }));
    }
  );

  app.post(
    base + "suggestManga",
    helpers.passport,
    (req: Request, res: Response) => {
      const { user } = req;
      console.log(user.id);
      User.findAll({ where: { id: { [Op.not]: user.id } } })
        .then((users) => {
          const mangaFreq: Map<string, number> = new Map<string, number>();

          users.forEach((otherUser) => {
            if (user["manga"].some((item) => otherUser["manga"].includes(item)))
              // contain similar manga
              for (const manga of otherUser["manga"]) {
                // adds to rec
                if (mangaFreq[manga] != null) mangaFreq[manga]++;
                else mangaFreq[manga] = 1;
              }
          });
          for (const manga of user["manga"]) delete mangaFreq[manga]; // delete if user already has manga

          const resManga = Object.keys(mangaFreq) // sort by frequency of appearance and get top 5
            .sort((a, b) => mangaFreq[b] - mangaFreq[a])
            .slice(0, 5);

          return res.status(200).json(helpers.success({ manga: resManga }));
        })
        .catch((e) => res.json(helpers.error(e.message)));
    }
  );
}
