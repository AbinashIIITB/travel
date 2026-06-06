-- indexes for travel_db

-- packages — used heavily on listing and filter pages
CREATE INDEX idx_packages_country_id ON packages (country_id);
CREATE INDEX idx_packages_starting_price ON packages (starting_price);
CREATE INDEX idx_packages_is_domestic ON packages (is_domestic);
CREATE INDEX idx_packages_slug ON packages (slug);

-- only index bestsellers since it's a small subset
CREATE INDEX idx_packages_is_bestseller ON packages (country_id) WHERE is_bestseller = true;

-- powers the search bar (title + description)
CREATE INDEX idx_packages_fts ON packages USING gin (to_tsvector('english', title || ' ' || COALESCE(description, '')));

-- countries
CREATE INDEX idx_countries_region_id ON countries (region_id);
CREATE INDEX idx_countries_is_domestic ON countries (is_domestic);
CREATE INDEX idx_countries_slug ON countries (slug);

-- for the "Where are you planning to go?" dropdown search
CREATE INDEX idx_countries_fts ON countries USING gin (to_tsvector('english', name));

-- destinations
CREATE INDEX idx_destinations_country_id ON destinations (country_id);
CREATE INDEX idx_destinations_fts ON destinations USING gin (to_tsvector('english', name));

-- package_images
CREATE INDEX idx_package_images_package_id ON package_images (package_id);

-- quick lookup for the cover image on listing cards
CREATE INDEX idx_package_images_cover ON package_images (package_id) WHERE is_cover = true;

-- package_themes — package_id is already covered by PK, just need theme_id
CREATE INDEX idx_package_themes_theme_id ON package_themes (theme_id);

-- package_cities
CREATE INDEX idx_package_cities_package_id ON package_cities (package_id);
CREATE INDEX idx_package_cities_destination_id ON package_cities (destination_id);

-- package_pricing
CREATE INDEX idx_package_pricing_package_id ON package_pricing (package_id);

-- package_amenities
CREATE INDEX idx_package_amenities_package_id ON package_amenities (package_id);

-- package_highlights
CREATE INDEX idx_package_highlights_package_id ON package_highlights (package_id);

-- itinerary_days
CREATE INDEX idx_itinerary_days_package_id ON itinerary_days (package_id);

-- itinerary_day_tags
CREATE INDEX idx_itinerary_day_tags_day_id ON itinerary_day_tags (itinerary_day_id);

-- itinerary_day_inclusions
CREATE INDEX idx_itinerary_day_inclusions_day_id ON itinerary_day_inclusions (itinerary_day_id);

-- itinerary_day_images
CREATE INDEX idx_itinerary_day_images_day_id ON itinerary_day_images (itinerary_day_id);

-- hotels
CREATE INDEX idx_hotels_destination_id ON hotels (destination_id);
CREATE INDEX idx_hotels_star_rating ON hotels (star_rating);

-- package_hotels
CREATE INDEX idx_package_hotels_package_id ON package_hotels (package_id);
CREATE INDEX idx_package_hotels_hotel_id ON package_hotels (hotel_id);
CREATE INDEX idx_package_hotels_star_rating ON package_hotels (hotel_star_rating);

-- fetch all hotels for a package at a specific star tier in one scan
CREATE INDEX idx_package_hotels_package_star ON package_hotels (package_id, hotel_star_rating);

-- package_inclusions / package_exclusions
CREATE INDEX idx_package_inclusions_package_id ON package_inclusions (package_id);
CREATE INDEX idx_package_exclusions_package_id ON package_exclusions (package_id);

-- faqs
CREATE INDEX idx_faqs_country_id ON faqs (country_id);
CREATE INDEX idx_faqs_package_id ON faqs (package_id);

-- quote_requests — sorted by latest first in admin view
CREATE INDEX idx_quote_requests_package_id ON quote_requests (package_id);
CREATE INDEX idx_quote_requests_created_at ON quote_requests (created_at DESC);
