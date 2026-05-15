const express = require ("express");
const app = express();
app.use(express.json());

app.use("/auth" , require ("./auth_and_users/auth_routes.js"));
//app.use("/locals" , require "./locals/locals_routes.js")
//app.use("/places" , require "./places/places_routes.js")






app.listen (3000, ()=> console.log ("server has booted succesfully"));