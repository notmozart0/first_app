const router = require("express").Router();
//const auth = require("./auth_and_users/auth_middleware.js");

router.get("/",(req,res)=>{
    res.send("hello")
})

module.exports = router;
