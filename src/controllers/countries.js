const q = require('../queries/countries');

// GET /api/countries/search?q=thai
const search = async (req, res, next) => {
  try {
    const { q: query } = req.query;
    if (!query || query.trim().length < 2) {
      return res.status(400).json({ error: 'Search query must be at least 2 characters' });
    }

    const { rows } = await q.searchCountries(query.trim());
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

// GET /api/countries/:slug/faqs
const getFaqs = async (req, res, next) => {
  try {
    const { rows } = await q.getFaqsByCountry(req.params.slug);
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

module.exports = { search, getFaqs };
