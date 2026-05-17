// let {reviews} = require('./reviews_data');
// fake data to test
let reviews=[
    {
        review_id:1,
        place_id:10,
        local_id:1,
        rating:4,
        review_text:'Great place to visit!',
        review_date: '2023-01-01'
    },
    {
        review_id:2,
        place_id:101,
        local_id:2,
        rating:5,
        review_text:'Great place to visit!',
        review_date: '2023-01-02'
    }
]
const{body, validationResult} = require('express-validator');


const get_all_reviews = (req,res)=>{
    res.json(reviews);
}

const get_reviews_by_place_id = (req,res)=>{

    const place_id = parseInt(req.params.place_id);    
    const place_reviews = reviews.filter(
        (review) => review.place_id === place_id
    );
    if (place_reviews.length==0){
        return res.status(404).json({error:'No reviews found for this place'});
    }
    res.json(place_reviews);
}

const add_review =

     (req,res)=>{

    console.log(req.body);
      const errors = validationResult(req);
    if (!errors.isEmpty()){
    //     return res.status(400).json({errors: errors.array()});
    }
   
    const review = ({review_id:reviews.length+1,...req.body});
    reviews.push(review);
    res.status(201).json(reviews);
}

const update_review = (req,res)=>{

    const review_id = parseInt(req.params.review_id); 
    let updated_review = reviews.find(
        (review) => review.review_id === review_id
    );
    if (!updated_review){
        return res.status(404).json({error:'Review not found'});
    }

    updated_review ={...updated_review,...req.body }
    
    res.status(200).json(updated_review)


}

const delete_review = (req,res)=>{

    const review_id = parseInt(req.params.review_id);
    reviews = reviews.filter(
        (review) => review.review_id !== review_id
    );
    res.status(200).json({message: 'Review deleted successfully'});
}
module.exports = {
    get_all_reviews, 
    get_reviews_by_place_id,
    add_review,
    update_review,
    delete_review,
}
