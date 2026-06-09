const router = require('express').Router();
const ctrl = require('../controllers/countries');

router.get('/search', ctrl.search);              // ?q=thai
router.get('/:slug/faqs', ctrl.getFaqs);

module.exports = router;
