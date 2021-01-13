import express from "express";
import bodyParser from "body-parser";
import middleWare from "../middleware/middleware.js";
import sequelize from "../config/db.js";

export async function createServer() {
  const app = express();
  app.use(bodyParser.json());
  //app.use(express.static("middleware/public"));
  middleWare(app);
  await sequelize.sync();

  return app;
}
