-- Travel Packages — database schema
-- all prices are stored in INR (no multi-currency for now)

-- regions drive the "Explore More" section on the homepage
-- e.g. Middle East, Oceania, South East Asia
CREATE TABLE regions (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  image_url TEXT,
  sort_order SMALLINT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- themes are the tile section on homepage (Romantic, Family, Solo, Adventure...)
CREATE TABLE themes (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  image_url TEXT,
  destination_count SMALLINT NOT NULL DEFAULT 0, -- just a display label like "60+"
  sort_order SMALLINT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- these are the colorful budget filter cards on the homepage
-- e.g. Below ₹50,000 / ₹75,000 / ₹1,00,000 etc.
CREATE TABLE budget_categories (
  id SERIAL PRIMARY KEY,
  label VARCHAR(100) NOT NULL, -- "Below ₹50,000"
  max_budget NUMERIC(12, 2) NOT NULL, -- 50000.00
  color_hex VARCHAR(7), -- hex color for the card bg
  sort_order SMALLINT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true
);

-- one row per destination card on the homepage
-- note: Dubai is treated as a "country" here even though it's a city, 
-- that's just how the UI groups things
CREATE TABLE countries (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL, -- "Dubai", "Thailand", "Andaman"
  slug VARCHAR(100) NOT NULL UNIQUE,
  region_id INT REFERENCES regions (id) ON DELETE SET NULL,
  image_url TEXT,
  visa_type VARCHAR(20) CHECK (
    visa_type IN ('visa_free', 'visa_on_arrival', 'e_visa', 'visa_required')
  ),
  best_time_to_visit VARCHAR(100), -- shown on card banner e.g. "Jul - Apr"
  package_count_label VARCHAR(20) NOT NULL DEFAULT '10+',
  is_domestic BOOLEAN NOT NULL DEFAULT false,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- cities or sub-regions inside a country
-- e.g. Phuket, Pattaya, Bangkok are all under Thailand
CREATE TABLE destinations (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  slug VARCHAR(150) NOT NULL,
  country_id INT NOT NULL REFERENCES countries (id) ON DELETE CASCADE,
  image_url TEXT,
  description TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (slug, country_id)
);

-- the main package table, each row = one tour package
-- starting_price is the lowest price across all hotel tiers (used on cards)
CREATE TABLE packages (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  country_id INT NOT NULL REFERENCES countries (id) ON DELETE RESTRICT,
  duration_days SMALLINT NOT NULL CHECK (duration_days > 0),
  duration_nights SMALLINT NOT NULL CHECK (duration_nights >= 0),
  short_description VARCHAR(500),
  description TEXT,
  starting_price NUMERIC(12, 2) NOT NULL CHECK (starting_price >= 0),
  best_time_to_visit VARCHAR(100), -- overrides the country-level value if set
  is_bestseller BOOLEAN NOT NULL DEFAULT false,
  is_domestic BOOLEAN NOT NULL DEFAULT false,
  is_active BOOLEAN NOT NULL DEFAULT true,
  meta_title VARCHAR(255),
  meta_description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- images for the gallery carousel on the package detail page
-- is_cover = true is what shows up as the thumbnail on listing pages
CREATE TABLE package_images (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  caption TEXT,
  sort_order SMALLINT NOT NULL DEFAULT 0,
  is_cover BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- many-to-many between packages and themes
CREATE TABLE package_themes (
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  theme_id INT NOT NULL REFERENCES themes (id) ON DELETE CASCADE,
  PRIMARY KEY (package_id, theme_id)
);

-- cities covered in a package with how many days spent there
-- shows up in the booking sidebar like: "Phuket (3D), Pattaya (2D), Bangkok (3D)"
CREATE TABLE package_cities (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  destination_id INT NOT NULL REFERENCES destinations (id) ON DELETE RESTRICT,
  duration_days SMALLINT NOT NULL CHECK (duration_days > 0),
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- pricing per hotel star tier (3*, 4*, 5*)
-- the user picks a star rating in the sidebar and this drives the price shown
CREATE TABLE package_pricing (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  hotel_star_rating SMALLINT NOT NULL CHECK (hotel_star_rating IN (3, 4, 5)),
  price_per_person NUMERIC(12, 2) NOT NULL CHECK (price_per_person >= 0),
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (package_id, hotel_star_rating)
);

-- the small amenity icons shown in the sidebar (Meals, Transfers)
-- star rating icon is NOT stored here, it's derived from the selected pricing row
CREATE TABLE package_amenities (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  label VARCHAR(100) NOT NULL, -- "Meals", "Transfers"
  icon_key VARCHAR(100), -- identifier used on the frontend
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- bullet list under the Highlights tab on the detail page
CREATE TABLE package_highlights (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  highlight_text TEXT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- one row per day in the itinerary accordion
-- day_number keeps them in order, no need for a separate sort_order
CREATE TABLE itinerary_days (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  day_number SMALLINT NOT NULL CHECK (day_number > 0),
  title VARCHAR(255) NOT NULL, -- "Arrival in Phuket. Evening Day at Leisure"
  description TEXT,
  location_name VARCHAR(150), -- city label shown on that day
  UNIQUE (package_id, day_number)
);

-- the green pill tags on each day row (Leisure Day, City Tour, Water Sports...)
CREATE TABLE itinerary_day_tags (
  id SERIAL PRIMARY KEY,
  itinerary_day_id INT NOT NULL REFERENCES itinerary_days (id) ON DELETE CASCADE,
  tag_name VARCHAR(100) NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- benefits/inclusions shown inside each expanded day accordion
-- e.g. "Cab Airport Transfers", "Lunch", "Dinner"
CREATE TABLE itinerary_day_inclusions (
  id SERIAL PRIMARY KEY,
  itinerary_day_id INT NOT NULL REFERENCES itinerary_days (id) ON DELETE CASCADE,
  inclusion_type VARCHAR(20) NOT NULL CHECK (
    inclusion_type IN ('meal', 'transfer', 'activity', 'accommodation')
  ),
  label VARCHAR(100) NOT NULL,
  icon_key VARCHAR(100),
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- photos shown inside each expanded day accordion (2-3 images)
CREATE TABLE itinerary_day_images (
  id SERIAL PRIMARY KEY,
  itinerary_day_id INT NOT NULL REFERENCES itinerary_days (id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  caption TEXT,
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- master hotel list, reusable across packages
CREATE TABLE hotels (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  destination_id INT NOT NULL REFERENCES destinations (id) ON DELETE RESTRICT,
  address TEXT,
  star_rating SMALLINT NOT NULL CHECK (star_rating BETWEEN 1 AND 5),
  image_url TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- links hotels to a package for a specific day range and star tier
-- when user selects "4*", only rows with hotel_star_rating = 4 are shown
CREATE TABLE package_hotels (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  hotel_id INT NOT NULL REFERENCES hotels (id) ON DELETE RESTRICT,
  destination_id INT NOT NULL REFERENCES destinations (id) ON DELETE RESTRICT,
  hotel_star_rating SMALLINT NOT NULL CHECK (hotel_star_rating IN (3, 4, 5)),
  day_from SMALLINT NOT NULL CHECK (day_from > 0),
  day_to SMALLINT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT valid_day_range CHECK (day_from <= day_to)
);

-- what's included in the package price (checklist on the Inclusions tab)
CREATE TABLE package_inclusions (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  inclusion_text TEXT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- what's NOT included (second tab in the Inclusions section)
CREATE TABLE package_exclusions (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages (id) ON DELETE CASCADE,
  exclusion_text TEXT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 0
);

-- FAQs shown at the bottom of the package detail page
-- can be scoped to a country ("FAQs for Thailand") or a specific package
CREATE TABLE faqs (
  id SERIAL PRIMARY KEY,
  package_id INT REFERENCES packages (id) ON DELETE CASCADE,
  country_id INT REFERENCES countries (id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  sort_order SMALLINT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  -- at least one of these must be set
  CONSTRAINT faq_must_have_scope CHECK (
    package_id IS NOT NULL OR country_id IS NOT NULL
  )
);

-- submitted when a user clicks "Get Exact Quote" on the detail page
-- no user accounts yet, all submissions are anonymous
CREATE TABLE quote_requests (
  id SERIAL PRIMARY KEY,
  package_id INT REFERENCES packages (id) ON DELETE SET NULL,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  travel_date DATE,
  num_adults SMALLINT NOT NULL DEFAULT 2 CHECK (num_adults >= 1),
  num_children SMALLINT NOT NULL DEFAULT 0 CHECK (num_children >= 0),
  hotel_star_preference SMALLINT CHECK (hotel_star_preference IN (3, 4, 5)),
  special_requirements TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
