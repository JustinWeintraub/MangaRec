import jwt from "jwt-then";
import { Request, Response, NextFunction } from "express";
import User from "../models/User.js";
import Manga from "../models/Manga.js";
const functions = {
  // makes sure user is authorized
  passport: function (req: Request, res: Response, next: NextFunction) {
    const token = req.headers.authorization;
    if (token) {
      jwt
        .verify(token, process.env.JWTKey)
        .then((user: any) =>
          User.findOne({ where: { username: user.username } })
        )
        .then((user) => {
          if (user == null) throw new Error("Invalid user.");
          req.user = user;
          next();
        })
        .catch((err) => res.json(functions.error(err.message)));
    } else {
      res.sendStatus(401);
    }
  },
  success: function (data?: any) {
    //TODO change param
    if (!data) data = {};
    data["success"] = true;
    return data;
  },
  error: function (msg: String) {
    return {
      message: msg,
      success: false,
    };
  },
  getManga: function (title: string) {
    return Manga.findOne({ where: { title: title } })
      .then((out) => {
        if (out == null) return null;
        else return out;
      })
      .catch(() => {
        return null;
      });
  },
};

export default functions;
