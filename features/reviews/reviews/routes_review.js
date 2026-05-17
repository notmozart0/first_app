const express = require('express');
const router= express.Router();

const reviews_controller = require('./reviews_controllers');    
const { validation_middleware } = require('./middel_ware');


router.route('/')
      .get(reviews_controller.get_all_reviews)
      .post(validation_middleware(),reviews_controller.add_review);



router.route('/place/:place_id')
     .get(reviews_controller.get_reviews_by_place_id)

router.route('/:review_id')
     .patch(reviews_controller.update_review)
     .delete(reviews_controller.delete_review)

module.exports = router;