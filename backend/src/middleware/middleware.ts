import mangaWare from "./manga.js"
import userWare from "./user.js"

export default function middleWare(app){
  mangaWare(app)
  userWare(app)
}