import {
  getAllMangaData,
  getMangaFromTags,
} from "../src/functionality/getManga";

test("gets singular manga data correctly", async () => {
  const mangaData = await getAllMangaData("One Piece");
  console.log(mangaData.authors);
  console.log(mangaData.cover);
  console.log(mangaData.url);
  expect(mangaData).toHaveProperty("title");
  expect(mangaData).toHaveProperty("cover");
  expect(mangaData).toHaveProperty("genres");
});
