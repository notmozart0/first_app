//sign up function 
const jwt_web_token = require("jsonwebtoken");
const env = require("dotenv").config();
const bcrypt = require("bcrypt");
// user example to test on
const users = [ {             
    first_name: 'ahmed',
    last_name: 'hello',
    phone_number: '012544',
    email: 'heo@fds',
    password: '$2b$10$ykC16qi2nV3HMYT4J1dzFOqCB3GxuQkQW4wAqg9O/185TJCPYjBPG'
    }];

const sign_up= async (req,res)=> {
    try{
        
        const { first_name , last_name , phone_number, email ,password  } = req.body
        const check_user = users.find((user) => user.email === email ) ;
        if (check_user) {
            return res.status(400).send("cannot create account with this email ");
        }

        const hashed_password = await bcrypt.hash(req.body.password , 10)
         // 
        users.push(
            {
                first_name :req.body.first_name,

                last_name :req.body.last_name,

               phone_number : req.body.phone_number,
                  
                 email : req.body.email,
                
                 role : "admin" ,
                 
                password : hashed_password
            }
        )
        //res.redirect("/login ")
        res.send("done")
        console.log (users);
        }
        
        catch (err){
            res.send("error");
           // res.redirect ("/sign_up")
    
        }

}

//login function 

const login = async (req,res)=>{
    try {
        const email = req.body.email;
        const unh_password = req.body.password;
       
        const e_user =users.find((user)=> user.email === email );
        if (!e_user ){
            res.status(400).send("not there u may want to sign_up first")//.redirect to sign up 
        }else if (e_user){
           const is_match = await bcrypt.compare (unh_password,e_user.password );
           if(is_match){
                 const access_token = jwt_web_token.sign({email :email,
                    role : "admin"}
                 ,process.env.ACCESS_TOKEN,{expiresIn : "30m"});
                

            
            return res.json({
                token : access_token
            });
           }
          if (!is_match) {return res.send("not the password i expected ");}
                    

                }
                
        }

        catch(err) {
        res.status (502).send(err.message )

               }
}
    
   


module.exports = {sign_up,users,login} ;
