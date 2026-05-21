const env = require("dotenv").config() ; 
const jwt = require("jsonwebtoken")

const role_function = {
    admin :[
        "add_place","add_local","delete_place","delete_local","delete_comment"
    ],
    user : [
                  "get_profile"
    ]


}



const jwt_auth =(req,res,next) =>{

    const header = req.headers.authorization ;
    if (!header ){
        return res.status(402).send("No token");
    }
    const token =header.split(" ")[1];
    const user =
    jwt.verify(
        token,
        process.env.ACCESS_TOKEN
    );
    req.user =user ; 
    next ();
    return user 
   

}





const can_user = (permission) => {

    return (req, res, next) => {

        const role = req.user.role;

        const is_allowed =
            role_function[role]
               ?.includes(permission);

        if (!is_allowed) {

            return res
                .status(403)
                .send("not allowed");

        }

        next();

    };

};







module.exports = {jwt_auth,can_user, role_function};
