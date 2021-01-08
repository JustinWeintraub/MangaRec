import express from "express";
import bodyParser from "body-parser";
import middleWare from "./src/middleware/middleware.js";
import initializer from "./src/init/init.js";
import sequelize from "./src/config/db.js";
import "./src/database/s3Connect.js";
import { autoUpdate } from "./src/functionality/updateManga.js";

const app = express();
app.use(bodyParser.json());
//app.use(express.static("middleware/public"));
middleWare(app);

(async () => {
  await sequelize.sync();
  initializer();
  autoUpdate();
  app.listen(8090, () => console.log("App listening on port 8090!"));
})();

// need to also open up for post and get requests

// backend TODO
// user: create manga score system, dict with entries allowed to not exist
// create authentication system
// frontend : create verification
// follow system (priority)
// user to watch anime
// manga
// get usable data (name, image, genre, views)
// frontend : get and display mangas with authentication
// machine learning
// test out data with test list

// get all manga?
