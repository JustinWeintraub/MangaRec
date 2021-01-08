import pkg from "sequelize";
import sequelize from "../config/db.js";
import bcrypt from "bcrypt";

const { DataTypes } = pkg;

const Manga = sequelize.define(
  "manga",
  {
    id: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false,
      unique: true,
    },
    title: {
      type: DataTypes.STRING,
      //primaryKey: true,
      allowNull: false,
      unique: true,
    },
    genres: {
      type: DataTypes.ARRAY(DataTypes.DECIMAL),
      allowNull: false,
    },
    views: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    authors: {
      type: DataTypes.ARRAY(DataTypes.STRING),
      allowNull: false,
      defaultValue: [],
    },
    url: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    cover: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    users: {
      type: DataTypes.ARRAY(DataTypes.NUMBER),
      defaultValue: [],
    },
  },
  {
    freezeTableName: true,
  }
);

Manga.sync({});

export default Manga;
