import { Sequelize } from "sequelize";

const sequelize = new Sequelize(
  "postgres",
  "postgres",
  process.env.SQL_PASSWORD,
  {
    dialect: "postgres",
    logging: console.log,
  }
);
export default sequelize;
