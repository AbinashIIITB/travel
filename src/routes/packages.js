const router = require('express').Router();
const ctrl = require('../controllers/packages');

router.get('/:slug', ctrl.getPackage);
router.get('/:slug/images', ctrl.getImages);
router.get('/:slug/pricing', ctrl.getPricing);
router.get('/:slug/highlights', ctrl.getHighlights);
router.get('/:slug/itinerary', ctrl.getItinerary);
router.get('/:slug/hotels', ctrl.getHotels);        // ?stars=4
router.get('/:slug/inclusions', ctrl.getInclusions);

module.exports = router;
