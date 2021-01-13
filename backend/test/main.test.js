/*import {
  getAllMangaData,
  getMangaFromTags,
  login,
} from "../src/functionality/getManga";*/
import "regenerator-runtime/runtime";

import request from "supertest";
import { createServer } from "../dist/src/config/createServer";

let server;

beforeAll(async () => {
  server = await createServer();
});
test("gets singular manga data correctly", async () => {
  /*await login();
  const mangaData = await getAllMangaData("One Piece");
  console.log(mangaData.authors);
  console.log(mangaData.cover);
  console.log(mangaData.url);
  expect(mangaData).toHaveProperty("title");
  expect(mangaData).toHaveProperty("cover");
  expect(mangaData).toHaveProperty("genres");*/
});

test("favoriting and ignoring works", async () => {
  // first get jwt
  let req = await request(server).post("/user/login").send({
    username: "TestYosh",
    password: process.env.SQLPASS,
  });
  expect(req.body.success).toBe(true);
  const jwt = req.body.jwt;

  // add manga
  req = await request(server)
    .post("/user/favoriteManga")
    .set({ authorization: jwt })
    .send({
      manga: "Tower of God",
    });
  expect(req.body.success).toBe(true);
  expect(req.body.manga).toEqual(expect.arrayContaining(["Tower of God"]));

  // un favorite
  req = await request(server)
    .post("/user/favoriteManga")
    .set({ authorization: jwt })
    .send({
      manga: "Tower of God",
    });
  expect(req.body.success).toBe(true);
  expect(req.body.manga).toEqual(expect.not.arrayContaining(["Tower of God"]));

  // add manga
  req = await request(server)
    .post("/user/favoriteManga")
    .set({ authorization: jwt })
    .send({
      manga: "Tower of God",
    });
  expect(req.body.success).toBe(true);
  expect(req.body.manga).toEqual(expect.arrayContaining(["Tower of God"]));

  // remove manga
  req = await request(server)
    .post("/user/ignoreManga")
    .set({ authorization: jwt })
    .send({
      manga: "Tower of God",
    });
  expect(req.body.success).toBe(true);
  expect(req.body.manga).toEqual(expect.not.arrayContaining(["Tower of God"]));
  expect(req.body.ignoredManga).toEqual(
    expect.arrayContaining(["Tower of God"])
  );

  // favorite manga
  req = await request(server)
    .post("/user/favoriteManga")
    .set({ authorization: jwt })
    .send({
      manga: "Tower of God",
    });
  expect(req.body.success).toBe(true);
  expect(req.body.manga).toEqual(expect.arrayContaining(["Tower of God"]));
  expect(req.body.ignoredManga).not.toEqual(
    expect.arrayContaining(["Tower of God"])
  );

  // un favorite
  req = await request(server)
    .post("/user/favoriteManga")
    .set({ authorization: jwt })
    .send({
      manga: "Tower of God",
    });
  expect(req.body.success).toBe(true);
  expect(req.body.manga).toEqual(expect.not.arrayContaining(["Tower of God"]));

  //console.log(await e);
});
