const db = require('../../db');

// Powers the "Explore More" section — just regions, ordered.
const getRegions = () => {
  return db.query(`
    SELECT id, name, slug, image_url
    FROM regions
    ORDER BY sort_order
  `);
};

// Powers the theme tiles — "Romantic (60+ destination)" etc.
const getThemes = () => {
  return db.query(`
    SELECT id, name, slug, image_url,
           destination_count || '+ destination' AS destination_label
    FROM themes
    ORDER BY sort_order
  `);
};

// Powers the "For every budget" colored cards.
const getBudgetCategories = () => {
  return db.query(`
    SELECT id, label, max_budget, color_hex
    FROM budget_categories
    ORDER BY sort_order
  `);
};

// Powers the "Bestseller International" country cards on the homepage.
// Each card shows the country name, image, best time to visit, visa badge,
// and the starting price pulled from the cheapest package for that country.
const getInternationalCountries = () => {
  return db.query(`
    SELECT
      c.id,
      c.name,
      c.slug,
      c.image_url,
      c.visa_type,
      c.best_time_to_visit,
      c.package_count_label,
      MIN(p.starting_price) AS starting_price
    FROM countries c
    LEFT JOIN packages p ON p.country_id = c.id
    WHERE c.is_domestic = false
    GROUP BY c.id
    ORDER BY c.id
  `);
};

// Powers the "Popular Domestic" country cards.
const getDomesticCountries = () => {
  return db.query(`
    SELECT
      c.id,
      c.name,
      c.slug,
      c.image_url,
      c.best_time_to_visit,
      c.package_count_label,
      MIN(p.starting_price) AS starting_price
    FROM countries c
    LEFT JOIN packages p ON p.country_id = c.id
    WHERE c.is_domestic = true
    GROUP BY c.id
    ORDER BY c.id
  `);
};

module.exports = {
  getRegions,
  getThemes,
  getBudgetCategories,
  getInternationalCountries,
  getDomesticCountries,
};
