const router = require('express').Router();
const ctrl = require('../controllers/quotes');

router.post('/', ctrl.createQuote);

module.exports = router;
