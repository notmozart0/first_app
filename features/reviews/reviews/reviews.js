const express = require('express'); 
const app = express();

app.use(express.json());

const reviews_router = require('./routes_review');
  
app.use('/api/reviews',reviews_router)



app.listen(5000, () => {
    console.log('Server is running on port 5000');
});

