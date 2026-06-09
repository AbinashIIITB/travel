const db = require('../../db');

// The main package detail query — everything the top section needs:
// title, duration, starting price, amenities, city breakdown, best time.
const getPackageBySlug = (slug) => {
  return db.query(
    `
    SELECT
      p.id,
      p.title,
      p.slug,
      p.duration_days,
      p.duration_nights,
      p.short_description,
      p.description,
      p.starting_price,
      p.best_time_to_visit,
      p.is_bestseller,
      c.name AS country_name,
      c.slug AS country_slug,
      -- city list for the sidebar: "Phuket (3D), Pattaya (2D), Bangkok (3D)"
      json_agg(
        json_build_object(
          'city', d.name,
          'days', pc.duration_days
        ) ORDER BY pc.sort_order
      ) AS cities,
      -- amenity icons for the sidebar
      (
        SELECT json_agg(json_build_object('label', a.label, 'icon', a.icon_key) ORDER BY a.sort_order)
        FROM package_amenities a
        WHERE a.package_id = p.id
      ) AS amenities
    FROM packages p
    JOIN countries c ON c.id = p.country_id
    LEFT JOIN package_cities pc ON pc.package_id = p.id
    LEFT JOIN destinations d ON d.id = pc.destination_id
    WHERE p.slug = $1
    GROUP BY p.id, c.name, c.slug
    `,
    [slug]
  );
};

// Gallery images for the carousel — ordered by sort_order.
const getPackageImages = (packageId) => {
  return db.query(
    `
    SELECT image_url, caption, sort_order, is_cover
    FROM package_images
    WHERE package_id = $1
    ORDER BY sort_order
    `,
    [packageId]
  );
};

// Pricing sidebar — the 3★/4★/5★ toggle.
const getPackagePricing = (packageId) => {
  return db.query(
    `
    SELECT hotel_star_rating, price_per_person
    FROM package_pricing
    WHERE package_id = $1
    ORDER BY hotel_star_rating DESC
    `,
    [packageId]
  );
};

// Highlights tab — the bulleted list.
const getPackageHighlights = (packageId) => {
  return db.query(
    `
    SELECT highlight_text
    FROM package_highlights
    WHERE package_id = $1
    ORDER BY sort_order
    `,
    [packageId]
  );
};

// Full itinerary — each day with its tags, inclusions, and images
// all bundled into the row so the frontend doesn't need to
// make a separate request per day.
const getPackageItinerary = (packageId) => {
  return db.query(
    `
    SELECT
      d.id,
      d.day_number,
      d.title,
      d.description,
      d.location_name,
      -- tags (the green pill badges on each day)
      COALESCE(
        (
          SELECT json_agg(t.tag_name ORDER BY t.sort_order)
          FROM itinerary_day_tags t
          WHERE t.itinerary_day_id = d.id
        ), '[]'
      ) AS tags,
      -- inclusions (the icon row — Meals, Transfers etc.)
      COALESCE(
        (
          SELECT json_agg(
            json_build_object('type', i.inclusion_type, 'label', i.label, 'icon', i.icon_key)
            ORDER BY i.sort_order
          )
          FROM itinerary_day_inclusions i
          WHERE i.itinerary_day_id = d.id
        ), '[]'
      ) AS inclusions,
      -- images inside the expanded day accordion
      COALESCE(
        (
          SELECT json_agg(
            json_build_object('url', img.image_url, 'caption', img.caption)
            ORDER BY img.sort_order
          )
          FROM itinerary_day_images img
          WHERE img.itinerary_day_id = d.id
        ), '[]'
      ) AS images
    FROM itinerary_days d
    WHERE d.package_id = $1
    ORDER BY d.day_number
    `,
    [packageId]
  );
};

// Hotels tab — filtered by the selected star rating from the sidebar toggle.
// star param comes from ?stars=4 on the request.
const getPackageHotels = (packageId, starRating) => {
  return db.query(
    `
    SELECT
      h.name,
      h.slug,
      h.address,
      h.star_rating,
      h.image_url,
      d.name AS city,
      ph.day_from,
      ph.day_to
    FROM package_hotels ph
    JOIN hotels h ON h.id = ph.hotel_id
    JOIN destinations d ON d.id = ph.destination_id
    WHERE ph.package_id = $1
      AND ph.hotel_star_rating = $2
    ORDER BY ph.sort_order
    `,
    [packageId, starRating]
  );
};

// Inclusions tab — what's included checklist.
const getPackageInclusions = (packageId) => {
  return db.query(
    `
    SELECT inclusion_text
    FROM package_inclusions
    WHERE package_id = $1
    ORDER BY sort_order
    `,
    [packageId]
  );
};

// Exclusions tab — what's not included.
const getPackageExclusions = (packageId) => {
  return db.query(
    `
    SELECT exclusion_text
    FROM package_exclusions
    WHERE package_id = $1
    ORDER BY sort_order
    `,
    [packageId]
  );
};

module.exports = {
  getPackageBySlug,
  getPackageImages,
  getPackagePricing,
  getPackageHighlights,
  getPackageItinerary,
  getPackageHotels,
  getPackageInclusions,
  getPackageExclusions,
};
