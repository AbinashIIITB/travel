const q = require('../queries/quotes');

// POST /api/quotes
// Body: { package_id, full_name, email, phone, travel_date,
//         num_adults, num_children, hotel_star_preference, message }
const createQuote = async (req, res, next) => {
  try {
    const { full_name, email, phone, num_adults } = req.body;

    // basic validation — only check the fields the form requires
    if (!full_name || !email || !phone || !num_adults) {
      return res.status(400).json({
        error: 'full_name, email, phone, and num_adults are required',
      });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'Invalid email address' });
    }

    if (num_adults < 1) {
      return res.status(400).json({ error: 'At least 1 adult is required' });
    }

    const { rows } = await q.createQuoteRequest(req.body);
    res.status(201).json({
      message: 'Quote request submitted successfully',
      data: rows[0],
    });
  } catch (err) {
    next(err);
  }
};

module.exports = { createQuote };
