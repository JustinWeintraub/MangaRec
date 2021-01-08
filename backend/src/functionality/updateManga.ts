import Manga from "../models/Manga.js";
import { getAllMangaData, login } from "../functionality/getManga.js";
import moment from "moment";
import pkg from "sequelize";
const { Op } = pkg;

// automatically update the data on the views of each manga
export async function autoUpdate() {
  const mangaData = await Manga.findAll({
    where: {
      updatedAt: {
        [Op.lte]: moment().subtract(7, "days").toDate(), // has to be 3 days ago
      },
    },
    order: [["updatedAt", "ASC"]],
  });
  //TODO cannot update blue period title
  const interval = 4000;
  await login();
  for (let i = 0; i < mangaData.length; i++) {
    setTimeout(() => updateSingular(mangaData[i]), interval * i);
  }
  setTimeout(
    () => autoUpdate(),
    interval * mangaData.length + 1000 * 60 * 60 * 24 * 1 // add a day to current time to redo this
  );
}

// updates a singular in database
async function updateSingular(manga) {
  try {
    const updatedManga = await getAllMangaData(manga["title"]);
    manga["views"] = updatedManga["views"];
    manga.save();
  } catch (e) {}
}
