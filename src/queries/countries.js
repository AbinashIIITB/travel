const db = require('../../db');

// Powers the search dropdown — "Where are you planning to go?"
// Uses the GIN full-text index on countries.name we created in indexes.sql.
// Falls back gracefully to an ILIKE if the query is very short.
const searchCountries = (q) => {
  return db.query(
    `
    SELECT id, name, slug, image_url, is_domestic
    FROM countries
    WHERE name ILIKE $1
    ORDER BY is_domestic, name
    LIMIT 10
    `,
    [`%${q}%`]
  );
};

// All FAQs for a country — shown at the bottom of the package detail page.
const getFaqsByCountry = (countrySlug) => {
  return db.query(
    `
    SELECT f.question, f.answer
    FROM faqs f
    JOIN countries c ON c.id = f.country_id
    WHERE c.slug = $1
    ORDER BY f.sort_order
    `,
    [countrySlug]
  );
};

module.exports = {
  searchCountries,
  getFaqsByCountry,
};
