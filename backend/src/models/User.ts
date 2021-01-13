import pkg from "sequelize";
import sequelize from "../config/db.js";
import bcrypt from "bcrypt";

const { DataTypes } = pkg;

// TODO https://medium.com/@jgrisafe/custom-user-authentication-with-express-sequelize-and-bcrypt-667c4c0edef5

let User = sequelize.define(
  "user",
  {
    username: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: {
        //args: true,
        name: "username", //TODO make sure this works
        msg: "Username already in use.",
      },
      validate: {
        is: ["[a-z]", "i"],
        len: [1, 100],
      },
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        validateRegex: function (value) {
          // TODO won't work because already hashed?
          if (
            !RegExp("^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$").test(value)
          ) {
            throw new Error(
              "The password needs to be at least 8 characters long, have one upper case and lower case number, and a number."
            );
          }
        },
        len: {
          args: [8, 42],
          msg: "The password length cannot be longer than 42 characters.",
        },
      },
    },
    // maybe have manga tiers here, manga1 2 3 4 5?
    // or nested data types
    manga: {
      type: DataTypes.ARRAY(DataTypes.STRING),
      defaultValue: [],
    },
    ignoredManga: {
      type: DataTypes.ARRAY(DataTypes.STRING),
      defaultValue: [],
    },
  },
  {
    freezeTableName: true,
  }
);

//TODO jest
User.prototype.generateHash = function (password) {
  return bcrypt.hash(password, bcrypt.genSaltSync(8));
};
(User.prototype.validPassword = (function (password) {})(
  //{ Sequelize, modelName: "user" }
  (User.prototype.toJSON = function () {
    var values = Object.assign({}, this.get());
    delete values.password;
    return values;
  })
)),
  User.beforeCreate((user: any, options) => {
    return bcrypt
      .hash(user.password, 10)
      .then((hash) => {
        user.password = hash;
      })
      .catch((err) => {
        throw new Error(err);
      });
  });

//User.sync({ force: true });

export default User;
