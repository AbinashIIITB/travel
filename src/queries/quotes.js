const db = require('../../db');

// Inserts a new quote request from the sidebar form.
// Returns the created row so the caller can confirm what was saved.
const createQuoteRequest = ({ package_id, full_name, email, phone, travel_date, num_adults, num_children, hotel_star_preference, message }) => {
  return db.query(
    `
    INSERT INTO quote_requests
      (package_id, full_name, email, phone, travel_date, num_adults, num_children, hotel_star_preference, message)
    VALUES
      ($1, $2, $3, $4, $5, $6, $7, $8, $9)
    RETURNING id, full_name, email, created_at
    `,
    [package_id, full_name, email, phone, travel_date, num_adults, num_children || 0, hotel_star_preference, message]
  );
};

module.exports = { createQuoteRequest };
