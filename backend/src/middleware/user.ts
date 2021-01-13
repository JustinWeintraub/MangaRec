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
  app.get(base + "users", (req: Request, res: Response) =>
    User.findAll().then((result) =>
      res.json(helpers.success({ result: result }))
    )
  );
  app.post(base + "register", (req: Request, res: Response) => {
    // TODO add way more to this
    User.create(req.body)
      .then(() => {
        return res.json(helpers.success());
      })

      .catch(function (e) {
        return res.json(helpers.error(e.helpers.errors[0].message));
      });
  });
  app.post(base + "login", (req: Request, res: Response) => {
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

  app.post(
    base + "favoriteManga",
    helpers.passport,
    async (req: Request, res: Response) => {
      const { user } = req;
      const { manga } = req.body;

      const out = await helpers.getManga(manga);
      if (out == null) return res.json(helpers.error("Invalid manga."));

      let userManga = user["manga"];
      let ignoredManga = user["ignoredManga"];
      if (userManga.includes(manga))
        userManga = userManga.filter((item) => item != manga);
      else {
        userManga.push(manga);
        ignoredManga = ignoredManga.filter((item) => item != manga);
      }

      User.update(
        {
          manga: userManga,
          ignoredManga: ignoredManga,
        },
        { where: { username: user["username"] } }
      ).then(() => {
        return res.json(
          helpers.success({
            manga: userManga,
            ignoredManga: ignoredManga,
          })
        );
      });
    }
  );

  app.post(
    base + "ignoreManga",
    helpers.passport,
    async (req: Request, res: Response) => {
      const { user } = req;
      const { manga } = req.body;

      const out = await helpers.getManga(manga);
      if (out == null) return res.json(helpers.error("Invalid manga."));

      let userManga = user["manga"];
      let ignoredManga = user["ignoredManga"];
      if (ignoredManga.includes(manga))
        ignoredManga = ignoredManga.filter((item) => item != manga);
      else {
        ignoredManga.push(manga);
        userManga = userManga.filter((item) => item != manga);
      }

      User.update(
        {
          manga: userManga,
          ignoredManga: ignoredManga,
        },
        { where: { username: user["username"] } }
      )
        .then(() => {
          return res.json(
            helpers.success({
              manga: userManga,
              ignoredManga: ignoredManga,
            })
          );
        })
        .catch((e) => res.json(helpers.error(e.message)));
    }
  );

  app.post(
    base + "getManga",
    helpers.passport,
    (req: Request, res: Response) => {
      res.status(200).json(
        helpers.success({
          manga: req.user["manga"],
          ignoredManga: req.user["ignoredManga"],
        })
      );
    }
  );

  app.post(
    base + "suggestManga",
    helpers.passport,
    (req: Request, res: Response) => {
      const { user } = req;
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
          for (const manga of user["manga"].concat(user["ignoredManga"]))
            delete mangaFreq[manga]; // delete if user already has manga or is ignoring

          const resManga = Object.keys(mangaFreq) // sort by frequency of appearance and get top 5
            .sort((a, b) => mangaFreq[b] - mangaFreq[a])
            .slice(0, 5);

          return res.status(200).json(helpers.success({ manga: resManga }));
        })
        .catch((e) => res.json(helpers.error(e.message)));
    }
  );
}
