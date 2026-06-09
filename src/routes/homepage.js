const router = require('express').Router();
const ctrl = require('../controllers/homepage');

router.get('/regions', ctrl.getRegions);
router.get('/themes', ctrl.getThemes);
router.get('/budget-categories', ctrl.getBudgetCategories);
router.get('/countries/international', ctrl.getInternationalCountries);
router.get('/countries/domestic', ctrl.getDomesticCountries);

module.exports = router;
