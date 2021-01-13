import initializer from "./src/init/init.js";
import "./src/database/s3Connect.js";
import { autoUpdate } from "./src/functionality/updateManga.js";
import { createServer } from "./src/config/createServer.js";

(async () => {
  const app = await createServer();
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
