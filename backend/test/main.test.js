import "regenerator-runtime/runtime";
import {
  getAllMangaData,
  getMangaFromTags,
  login,
} from "../src/functionality/getManga";

test("gets singular manga data correctly from Mangadex", async () => {
  await login();
  const mangaData = await getAllMangaData("One Piece");
  console.log(mangaData.authors);
  console.log(mangaData.cover);
  console.log(mangaData.url);
  expect(mangaData).toHaveProperty("title");
  expect(mangaData).toHaveProperty("cover");
  expect(mangaData).toHaveProperty("genres");
});
