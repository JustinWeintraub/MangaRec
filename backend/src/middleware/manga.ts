import { getImageFromId } from "../database/s3Connect.js";
import Manga from "../models/Manga.js";
import helpers from "./helpers.js";

import { Application, Request, Response } from "express";

import pkg from "sequelize";
const { Op } = pkg;

const base = "/manga/";
export default function mangaWare(app: Application) {
  app.post(
    base + "getAll",
    helpers.passport,
    (req: Request, res: Response) => {
      const { user } = req;
      const { sortVal, sortDir, title, genres } = req.body;
      Manga.findAll({
        order: [[sortVal, sortDir]],
        where: {
          title: { [Op.notIn]: user["ignoredManga"], [Op.iLike]: `%${title}%` },
          genres: { [Op.overlap]: genres },
        },
      })
        .then((result) => res.json(helpers.success({ manga: result })))
        .catch((e) => res.json(helpers.error(e.message)));
    }
    //const json = JSON.stringify(result);
  );
  app.get(
    base + "getCover/:id",
    helpers.passport,
    async (req: Request, res: Response, next) => {
      const image = await getImageFromId(
        "mangarec-bucket",
        req.params.id + ".jpg"
      );
      if (image) return res.json(helpers.success(image));
      else next("Id not found.");
    }
  );
  app.post(
    base + "getManga",
    helpers.passport,
    (req: Request, res: Response) => {
      Manga.findOne({ where: { title: req.body.manga } })
        .then((manga) =>
          res.status(200).json(helpers.success({ manga: manga }))
        )
        .catch((e) => res.json(helpers.error(e.message)));
    }
  );
}

// TODO
// there should a filter get all for database
// should never return all
