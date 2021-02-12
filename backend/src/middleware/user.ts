import User from "../models/User.js";
import * as rec from "../functionality/rec.js";
const base = "/user/";
import bcrypt from "bcrypt";
import jwt from "jwt-then";
import helpers from "./helpers.js";
import { Application, Request, Response } from "express";
import pkg from "sequelize";
import { checkVerification, createVerification } from "../connect/twilio.js";
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
      .then(async (user) => {
        setTimeout(function () {
          //deletes itself if not verified in a day
          User.findOne({ where: { id: user["id"] } }).then((sameUser) => {
            if (!sameUser["verified"])
              User.destroy({ where: { id: user["id"] } });
          });
        }, 1000 * 60 * 60 * 24 * 1);

        if (await createVerification(user["email"]))
          return res.json(helpers.success());
        else {
          User.destroy({ where: { id: user["id"] } });
          return res.json(helpers.error("Validation creation failed."));
        }
      })

      .catch(function (e) {
        if (!e.helpers) return res.json(helpers.error(e.errors[0].message));
        //e.helpers ?
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
        if (!user["verified"])
          return res.json(helpers.error("User not validated."));
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
      .catch((e) => res.json(helpers.error(e.message)));
  });

  app.post(base + "validate", (req: Request, res: Response) => {
    //TODO combine login and validate
    const { username, password, code } = req.body;
    User.findOne({ where: { username: username } })
      .then(async (user) => {
        if (!user) return res.json(helpers.error("Incorrect username"));
        //TODO move this?
        if (!(await bcrypt.compareSync(password, user["password"])))
          return res.json(helpers.error("Incorrect password"));
        if (await checkVerification(user["email"], code)) {
          User.update(
            {
              verified: true,
            },
            { where: { username: user["username"] } }
          ).then(async () =>
            res.json(
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
            )
          );
        } else return res.json(helpers.error("Validation failed."));
      })
      .catch((e) => res.json(helpers.error(e.message)));
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
          const allUsers = Array.from(users);
          allUsers.push(user);
          const dataset = rec.convertUsersToDataset(allUsers);
          const resManga = rec.recommendationEng(
            dataset,
            user["username"],
            rec.euclideanScore
          );

          return res.status(200).json(helpers.success({ manga: resManga }));
        })
        .catch((e) => res.json(helpers.error(e.message)));
    }
  );
}
