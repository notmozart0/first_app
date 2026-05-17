
const{body} = require('express-validator');
const validation_middleware = () => {
 return [
   body('review_text')
     .notEmpty()
     .withMessage('Review text is required'),
    
    
    body('rating')
      .isInt({min:1, max:5})
      .notEmpty()
      .withMessage('Rating must be an integer between 1 and 5'),
                 
    body('place_id')
     .isInt()
     .notEmpty()
     .withMessage('Place ID must be an integer'),
    body('local_id')
     .isInt()
     .notEmpty()
     .withMessage('Local ID must be an integer'),
    body('review_date')
     .isISO8601()
     .notEmpty()
     .withMessage('Review date must be a valid date in ISO 8601 format')
    
] 
        }
module.exports = {
    validation_middleware
};