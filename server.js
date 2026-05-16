require("dotenv").config();
const express = require ("express");
const app = express();
app.use(express.json());
const {router} = require ("./auth_and_users/auth_routes.js")
app.use("/auth" , router);
//app.use("/locals" , require "./locals/locals_routes.js")
//app.use("/places" , require "./places/places_routes.js")






app.listen (process.env.port, ()=> console.log ("server has booted succesfully"));