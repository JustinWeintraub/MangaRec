// TODO file is temporarily unused due to data being already initialized
import Manga from "../models/Manga.js";
import {
  getAllMangaData,
  getMangaFromTags,
  login,
} from "../functionality/getManga.js";
import { uploadImageFromUrl } from "../database/s3Connect.js";
import * as originalData from "../../dataComplete.json";
import { createRequire } from "module";
const require = createRequire(import.meta.url);
const fs = require("fs");

const timer = (ms) => new Promise((res) => setTimeout(res, ms));

function parseJson(data: any) {
  console.log(Object.getOwnPropertyNames(data["default"]));
  //return JSON.parse(data);
}

export default async function initializeManga() {
  Manga.findAll().then(async (result) => {
    if (result.length == 0) {
      Manga.bulkCreate(originalData["default"]);
    }
    /*
    //Manga.create(originalData["default"][0]);
    //Manga.bulkCreate(originalData["default"]);
    //if (result.length == -4) {
    result = await getMangaFromTags([
      { tag: "2", amount: 50 },
      { tag: "31", amount: 50 },
      { tag: "5", amount: 50 },
      { tag: "4", amount: 150 },
      { tag: "3", amount: 50 },
      { tag: "1", amount: 10 },
      { tag: "6", amount: 5 },
      { tag: "10", amount: 50 },
      { tag: "11", amount: 10 },
      { tag: "23", amount: 60 },
      { tag: "25", amount: 50 },
      { tag: "31", amount: 50 },
      { tag: "33", amount: 25 },
      { tag: "34", amount: 50 },
      { tag: "35", amount: 10 },
      { tag: "40", amount: 20 },
      { tag: "3", amount: 50 },
      { tag: "54", amount: 15 },
      { tag: "55", amount: 15 },
      { tag: "53", amount: 10 },
      { tag: "72", amount: 10 },
      { tag: "78", amount: 5 },
      { tag: "41", amount: 5 },
    ]);
    let dictstring = JSON.stringify(result);
    fs.writeFile("../data.json", dictstring, function (err, result) {
      if (err) console.log("error", err);
    });

    //Manga.bulkCreate(result);
    result = originalData["default"];
    await login();

    const numList = [0];
    //150-168 170-191 194 195
    for (let i = 0; i < result.length; i++) {
      try {
        uploadImageFromUrl(
          "mangadex.org" + result[i]["cover"],
          result[i]["id"]
        );
        if (!result[i]["genres"])
          result[i] = await getAllMangaData(result[i]["title"]);
      } catch (e) {
        console.log("WE BROKE");
      }
    }
    let dictstring = JSON.stringify(result);
    fs.writeFile("../dataComplete.json", dictstring, function (err, result) {
      if (err) console.log("error", err);
    });
    //
    //}
    if (!result[0]["genres"]) {
      const completeResult = [];
    }*/
  });
}
