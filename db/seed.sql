-- =============================================================================
-- Easy Travel Packages — Complete Seed Data
-- Extracted from UI screenshots (6 pages).
-- Run order: schema.sql → indexes.sql → seed.sql
-- All prices are in INR (₹).
-- =============================================================================

BEGIN;

-- =============================================================================
-- SECTION 1 — REGIONS
-- Powers: "Explore More" section on homepage
-- Screenshot: 4 tiles visible — Middle East, Oceania, South East Asia, Scandinavia
-- =============================================================================
INSERT INTO regions (name, slug, image_url, sort_order) VALUES
  ('Middle East',     'middle-east',     '/images/regions/middle-east.jpg',     1),
  ('Oceania',         'oceania',         '/images/regions/oceania.jpg',          2),
  ('South East Asia', 'south-east-asia', '/images/regions/south-east-asia.jpg', 3),
  ('Scandinavia',     'scandinavia',     '/images/regions/scandinavia.jpg',      4);


-- =============================================================================
-- SECTION 2 — THEMES
-- Powers: "Themes" section tiles on homepage
-- Screenshot: Romantic (60+), Family (70+), Friends (10+),
--             Solo (110+), Adventure (30+), Nature (100+)
-- =============================================================================
INSERT INTO themes (name, slug, image_url, destination_count, sort_order) VALUES
  ('Romantic',  'romantic',  '/images/themes/romantic.jpg',  60,  1),
  ('Family',    'family',    '/images/themes/family.jpg',    70,  2),
  ('Friends',   'friends',   '/images/themes/friends.jpg',   10,  3),
  ('Solo',      'solo',      '/images/themes/solo.jpg',      110, 4),
  ('Adventure', 'adventure', '/images/themes/adventure.jpg', 30,  5),
  ('Nature',    'nature',    '/images/themes/nature.jpg',    100, 6);


-- =============================================================================
-- SECTION 3 — BUDGET CATEGORIES
-- Powers: "For every budget" colored filter cards on homepage
-- Screenshot: 5 cards with distinct background colors
-- =============================================================================
INSERT INTO budget_categories (label, max_budget, color_hex, sort_order) VALUES
  ('Below ₹50,000',    50000.00,  '#7C3AED', 1),  -- purple
  ('Below ₹75,000',    75000.00,  '#059669', 2),  -- green
  ('Below ₹1,00,000', 100000.00,  '#D97706', 3),  -- orange/amber
  ('Below ₹2,00,000', 200000.00,  '#2563EB', 4),  -- blue
  ('Below ₹3,00,000', 300000.00,  '#DB2777', 5);  -- pink


-- =============================================================================
-- SECTION 4 — COUNTRIES (International)
-- Powers: "Bestseller International" cards on homepage
-- Screenshot: Dubai (Visa on Arrival), Maldives (Visa on Arrival), Sri Lanka (Visa Free)
-- Note: All cards show "Best time to visit Jul - Apr" and "10+ destination"
--       as visible in screenshot card banners.
-- Note: Dubai is a city in UAE but modeled as a country-level entity
--       because the UI treats it at the same level as Thailand/Maldives.
-- =============================================================================
INSERT INTO countries
  (name, slug, region_id, image_url, visa_type, best_time_to_visit, package_count_label, is_domestic)
SELECT
  c.name, c.slug,
  r.id,
  c.image_url,
  c.visa_type,
  c.best_time_to_visit,
  '10+',
  false
FROM (VALUES
  ('Thailand',  'thailand',  'south-east-asia', '/images/countries/thailand.jpg',  'visa_on_arrival', 'Jul - Apr'),
  ('Dubai',     'dubai',     'middle-east',     '/images/countries/dubai.jpg',     NULL,              'Jul - Apr'),
  ('Maldives',  'maldives',  'oceania',         '/images/countries/maldives.jpg',  'visa_on_arrival', 'Jul - Apr'),
  ('Sri Lanka', 'sri-lanka', 'south-east-asia', '/images/countries/sri-lanka.jpg', 'visa_free',       'Jul - Apr'),
  ('Singapore', 'singapore', 'south-east-asia', '/images/countries/singapore.jpg', 'visa_free',       'Jul - Apr'),
  ('Bali',      'bali',      'south-east-asia', '/images/countries/bali.jpg',      'visa_on_arrival', 'Jul - Apr'),
  ('Vietnam',   'vietnam',   'south-east-asia', '/images/countries/vietnam.jpg',   'e_visa',          'Jul - Apr'),
  ('Malaysia',  'malaysia',  'south-east-asia', '/images/countries/malaysia.jpg',  'visa_free',       'Jul - Apr')
) AS c(name, slug, region_slug, image_url, visa_type, best_time_to_visit)
JOIN regions r ON r.slug = c.region_slug;


-- =============================================================================
-- SECTION 5 — COUNTRIES (Domestic / India)
-- Powers: "Popular Domestic" section on homepage
-- Screenshot: Andaman, Goa, Kerala, Himachal,
--             Sikkim-Gangtok-Darjeeling, Kashmir
--             All show "Best time to visit Jul - Apr" and "10+ destination"
-- =============================================================================
INSERT INTO countries
  (name, slug, region_id, image_url, visa_type, best_time_to_visit, package_count_label, is_domestic)
VALUES
  ('Andaman',                  'andaman',                  NULL, '/images/countries/andaman.jpg',   NULL, 'Jul - Apr', '10+', true),
  ('Goa',                      'goa',                      NULL, '/images/countries/goa.jpg',        NULL, 'Jul - Apr', '10+', true),
  ('Kerala',                   'kerala',                   NULL, '/images/countries/kerala.jpg',     NULL, 'Jul - Apr', '10+', true),
  ('Himachal',                 'himachal',                 NULL, '/images/countries/himachal.jpg',   NULL, 'Jul - Apr', '10+', true),
  ('Sikkim-Gangtok-Darjeeling','sikkim-gangtok-darjeeling',NULL, '/images/countries/sikkim.jpg',     NULL, 'Jul - Apr', '10+', true),
  ('Kashmir',                  'kashmir',                  NULL, '/images/countries/kashmir.jpg',    NULL, 'Jul - Apr', '10+', true);


-- =============================================================================
-- SECTION 6 — DESTINATIONS
-- Cities within Thailand used by the package detail page.
-- Screenshot sidebar: "Phuket (3D), Pattaya (2D), Bangkok (3D)"
-- =============================================================================
INSERT INTO destinations (name, slug, country_id, image_url, description)
SELECT d.name, d.slug, c.id, d.image_url, d.description
FROM (VALUES
  ('thailand', 'Phuket',  'phuket',  '/images/destinations/phuket.jpg',  'Island province in southern Thailand, famous for beaches, nightlife, and water sports.'),
  ('thailand', 'Pattaya', 'pattaya', '/images/destinations/pattaya.jpg', 'Coastal resort city known for entertainment, Coral Island, and the Alcazar Show.'),
  ('thailand', 'Bangkok', 'bangkok', '/images/destinations/bangkok.jpg', 'Thailand''s capital city, home to temples, palaces, SEA Life, and Madame Tussaud''s.')
) AS d(country_slug, name, slug, image_url, description)
JOIN countries c ON c.slug = d.country_slug;


-- =============================================================================
-- SECTION 7 — PACKAGES
-- Screenshot: Thailand package detail page
-- Title: "Fascinating Thailand Tour Packages For A Happening Thailand Vacation"
-- Duration: 8 Days & 7 Nights
-- Starting price: ₹33,000 (shown on homepage card and sidebar)
-- is_bestseller: true (shown in "Bestseller International" section)
-- =============================================================================
INSERT INTO packages
  (title, slug, country_id, duration_days, duration_nights,
   short_description, description,
   starting_price, best_time_to_visit,
   is_bestseller, is_domestic,
   meta_title, meta_description)
SELECT
  'Fascinating Thailand Tour Packages For A Happening Thailand Vacation',
  'fascinating-thailand-tour-packages',
  c.id,
  8,
  7,
  'Best Of Thailand Package — Best Family Places In And Outside India For An Amazing Holiday',
  'Vacations are a great way to spend time with friends and families. Be it summer vacations or family picnics, travelling serves as the perfect entertainment. While there are so many places to visit in India for a regular vacation, there are only a few places that offer the best family holiday experience. Choosing a holiday destination, especially for a family vacation, may not always be an easy task. Therefore, we have short-listed the top five family places in and outside India that you can visit on a vacation.',
  33000.00,
  'Jul - Apr',
  true,
  false,
  'Thailand Tour Packages 8 Days 7 Nights | Starting ₹33,000',
  'Explore the best Thailand tour packages covering Phuket, Pattaya and Bangkok in 8 days 7 nights. Includes Phi Phi Island, Safari World, Alcazar Show and more.'
FROM countries c
WHERE c.slug = 'thailand';


-- =============================================================================
-- SECTION 8 — PACKAGE IMAGES
-- Screenshot: Carousel shown as "1 of 8" on package detail page.
-- Actual image URLs not visible — using descriptive placeholder paths.
-- Caption visible: "A caption of this photo from Phuket"
-- =============================================================================
INSERT INTO package_images (package_id, image_url, caption, sort_order, is_cover)
SELECT
  p.id,
  img.image_url,
  img.caption,
  img.sort_order,
  img.is_cover
FROM packages p
CROSS JOIN (VALUES
  ('/images/packages/thailand/phuket-beach.jpg',       'A caption of this photo from Phuket',   1, true),
  ('/images/packages/thailand/phi-phi-island.jpg',     'Phi Phi Island — one of Thailand''s most beautiful islands', 2, false),
  ('/images/packages/thailand/bangkok-temple.jpg',     'The enchanting temples of Bangkok',      3, false),
  ('/images/packages/thailand/pattaya-coral.jpg',      'Coral Island tour from Pattaya',         4, false),
  ('/images/packages/thailand/safari-world.jpg',       'Safari World with Marine Park, Bangkok', 5, false),
  ('/images/packages/thailand/alcazar-show.jpg',       'Alcazar Show — Pattaya',                 6, false),
  ('/images/packages/thailand/sea-life-bangkok.jpg',   'SEA Life Bangkok Ocean World',           7, false),
  ('/images/packages/thailand/gems-gallery.jpg',       'Phuket Gems Gallery',                    8, false)
) AS img(image_url, caption, sort_order, is_cover)
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 9 — PACKAGE THEMES
-- Thailand package tagged as Family and Adventure based on UI content
-- =============================================================================
INSERT INTO package_themes (package_id, theme_id)
SELECT p.id, t.id
FROM packages p, themes t
WHERE p.slug = 'fascinating-thailand-tour-packages'
  AND t.slug IN ('family', 'adventure');


-- =============================================================================
-- SECTION 10 — PACKAGE CITIES
-- Screenshot sidebar: "Cities: Phuket (3D), Pattaya (2D), Bangkok (3D)"
-- =============================================================================
INSERT INTO package_cities (package_id, destination_id, duration_days, sort_order)
SELECT p.id, d.id, city.duration_days, city.sort_order
FROM packages p
CROSS JOIN (VALUES
  ('phuket',  3, 1),
  ('pattaya', 2, 2),
  ('bangkok', 3, 3)
) AS city(slug, duration_days, sort_order)
JOIN destinations d ON d.slug = city.slug
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 11 — PACKAGE PRICING
-- Screenshot sidebar: Star selector shows 5 Star / 4 Star / 3 Star
-- Starting from ₹33,000 shown → that is the 4★ price (lowest visible)
-- =============================================================================
INSERT INTO package_pricing (package_id, hotel_star_rating, price_per_person)
SELECT p.id, tier.stars, tier.price
FROM packages p
CROSS JOIN (VALUES
  (5, 43000.00),
  (4, 33000.00),
  (3, 25000.00)
) AS tier(stars, price)
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 12 — PACKAGE AMENITIES
-- Screenshot sidebar icons: 5 Stars (dynamic), Meals, Transfers
-- Only Meals and Transfers stored here.
-- The star label is derived from the selected package_pricing row.
-- =============================================================================
INSERT INTO package_amenities (package_id, label, icon_key, sort_order)
SELECT p.id, a.label, a.icon_key, a.sort_order
FROM packages p
CROSS JOIN (VALUES
  ('Meals',     'icon-meal',     1),
  ('Transfers', 'icon-transfer', 2)
) AS a(label, icon_key, sort_order)
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 13 — PACKAGE HIGHLIGHTS
-- Screenshot "Highlights" tab — 4 bullet points with star icons
-- =============================================================================
INSERT INTO package_highlights (package_id, highlight_text, sort_order)
SELECT p.id, h.highlight_text, h.sort_order
FROM packages p
CROSS JOIN (VALUES
  ('Go for an excursion to Phi Phi Island',            1),
  ('Enjoy the James Bond Island Tour',                 2),
  ('Go for the enchanting Bangkok Temple Tour',        3),
  ('Pay a visit to the Safari World in Bangkok',       4)
) AS h(highlight_text, sort_order)
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 14 — ITINERARY DAYS
-- Screenshot: Day 1, 2, 3 expanded / Day 5, 6, 7, 8 visible
-- Day 4 not visible in screenshots — inferred as transfer day (Phuket → Pattaya)
-- =============================================================================
INSERT INTO itinerary_days (package_id, day_number, title, description, location_name)
SELECT p.id, d.day_number, d.title, d.description, d.location_name
FROM packages p
CROSS JOIN (VALUES

  (1,
   'Arrival in Phuket. Evening Day at Leisure',
   'Welcome to the beautiful city of Phuket. Land to a warm reception in Phuket, our representative will be there to transfer you to your hotel in Phuket Town for check-in. The evening is offered at leisure. Enjoy dinner and overnight stay at the Phuket hotel.',
   'Phuket'),

  (2,
   'Phuket City Tour with Gems Gallery',
   'On the second day, you will see the beautiful landscape of Phuket while you are driven along the roads of the famous beaches Patong Beach, Karon Beach, and Kata Beach. Next, you will see the spellbinding Three Beaches viewpoint and see beautiful bays like Kata, Karon, Kata Noi, and Koh Pu Island. You will also explore Pearl of the Andaman and see gorgeous places like Wat Chalong, a Cashew Nut Factory, and Gems Factory. After the city tour, you will be transferred to your hotel for a relaxing overnight stay at the hotel.',
   'Phuket'),

  (3,
   'Phi-Phi Island Tour by Big Boat and Local Lunch',
   'Today you will visit the famous Phi Phi Islands by Big Boat. Explore the stunning limestone cliffs, emerald waters, and white sandy beaches. Enjoy snorkelling and a local Thai lunch on the island before returning to Phuket in the evening.',
   'Phuket'),

  (4,
   'Transfer from Phuket to Pattaya',
   'After breakfast, check out from the Phuket hotel and transfer to Phuket International Airport for your flight to Pattaya. Upon arrival, our representative will transfer you to your Pattaya hotel for check-in. The rest of the evening is at leisure.',
   'Pattaya'),

  (5,
   'Pattaya – Coral Island Tour + Alcazar Show',
   'After breakfast, proceed for the Coral Island tour by speedboat. Enjoy water sports activities like banana boat ride, parasailing, and snorkelling in the crystal clear waters. In the evening, enjoy the world-famous Alcazar Cabaret Show, one of the most popular entertainment shows in Pattaya.',
   'Pattaya'),

  (6,
   'Bangkok: SEA Life and Madame Tussaud''s',
   'After breakfast, check out and transfer to Bangkok. Visit the SEA Life Bangkok Ocean World, one of the largest aquariums in South East Asia. In the afternoon, visit Madame Tussaud''s Bangkok and get up close with wax figures of your favourite celebrities. Overnight stay in Bangkok.',
   'Bangkok'),

  (7,
   'Bangkok - Safari World With Marine Park',
   'Today''s highlight is the famous Safari World with Marine Park. Drive through the open zoo and see wildlife in their natural habitat. Visit the Marine Park for exciting shows including bird shows, sea lion shows, and the Hollywood Cowboy stunt show. Overnight stay in Bangkok.',
   'Bangkok'),

  (8,
   'Departure from Bangkok',
   'After breakfast, check out from the hotel. Our representative will transfer you to Bangkok Suvarnabhumi International Airport for your departure flight back home. Tour ends with wonderful memories.',
   'Bangkok')

) AS d(day_number, title, description, location_name)
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 15 — ITINERARY DAY TAGS
-- Screenshot: Green pill tags visible on each day row
-- Day 1: Leisure Day
-- Day 2: City Tour, Gems Gallery
-- Day 3: Phi-Phi Island Tour, Water Sports
-- Day 5: Coral Island Tour, Alcazar Show
-- Day 6: SEA LIFE Bangkok Ocean World
-- Day 7: Safari World, Safari
-- Day 8: Transfers
-- =============================================================================
INSERT INTO itinerary_day_tags (itinerary_day_id, tag_name, sort_order)
SELECT id_day.id, tag.tag_name, tag.sort_order
FROM itinerary_days id_day
JOIN packages p ON p.id = id_day.package_id
CROSS JOIN LATERAL (
  VALUES
    -- Day 1
    (1, 'Leisure Day',          1),
    -- Day 2
    (2, 'City Tour',            1),
    (2, 'Gems Gallery',         2),
    -- Day 3
    (3, 'Phi-Phi Island Tour',  1),
    (3, 'Water Sports',         2),
    -- Day 4
    (4, 'Transfers',            1),
    -- Day 5
    (5, 'Coral Island Tour',    1),
    (5, 'Alcazar Show',         2),
    -- Day 6
    (6, 'SEA LIFE Bangkok Ocean World', 1),
    -- Day 7
    (7, 'Safari World',         1),
    (7, 'Safari',               2),
    -- Day 8
    (8, 'Transfers',            1)
) AS tag(day_num, tag_name, sort_order)
WHERE p.slug = 'fascinating-thailand-tour-packages'
  AND id_day.day_number = tag.day_num;


-- =============================================================================
-- SECTION 16 — ITINERARY DAY INCLUSIONS
-- Screenshot: "Benefits on arrival" icon row inside each expanded day
-- Day 1: Cab Airport Transfers, Lunch, Dinner
-- Day 2: Meals, Transfers
-- =============================================================================
INSERT INTO itinerary_day_inclusions (itinerary_day_id, inclusion_type, label, icon_key, sort_order)
SELECT id_day.id, inc.inclusion_type, inc.label, inc.icon_key, inc.sort_order
FROM itinerary_days id_day
JOIN packages p ON p.id = id_day.package_id
CROSS JOIN LATERAL (
  VALUES
    -- Day 1: Cab Airport Transfers, Lunch, Dinner
    (1, 'transfer', 'Cab Airport Transfers', 'icon-cab',    1),
    (1, 'meal',     'Lunch',                 'icon-meal',   2),
    (1, 'meal',     'Dinner',                'icon-meal',   3),
    -- Day 2: Meals, Transfers
    (2, 'meal',     'Meals',                 'icon-meal',   1),
    (2, 'transfer', 'Transfers',             'icon-car',    2),
    -- Day 3: Meals, Transfers
    (3, 'meal',     'Meals',                 'icon-meal',   1),
    (3, 'transfer', 'Transfers',             'icon-car',    2),
    -- Day 4: Meals, Transfers
    (4, 'meal',     'Meals',                 'icon-meal',   1),
    (4, 'transfer', 'Transfers',             'icon-car',    2),
    -- Day 5: Meals, Transfers
    (5, 'meal',     'Meals',                 'icon-meal',   1),
    (5, 'transfer', 'Transfers',             'icon-car',    2),
    -- Day 6: Meals, Transfers
    (6, 'meal',     'Meals',                 'icon-meal',   1),
    (6, 'transfer', 'Transfers',             'icon-car',    2),
    -- Day 7: Meals, Transfers
    (7, 'meal',     'Meals',                 'icon-meal',   1),
    (7, 'transfer', 'Transfers',             'icon-car',    2),
    -- Day 8: Transfers only
    (8, 'transfer', 'Transfers',             'icon-car',    1)
) AS inc(day_num, inclusion_type, label, icon_key, sort_order)
WHERE p.slug = 'fascinating-thailand-tour-packages'
  AND id_day.day_number = inc.day_num;


-- =============================================================================
-- SECTION 17 — ITINERARY DAY IMAGES
-- Screenshot: 2 photos shown inside Day 1 and Day 2 expanded accordions
-- =============================================================================
INSERT INTO itinerary_day_images (itinerary_day_id, image_url, caption, sort_order)
SELECT id_day.id, img.image_url, img.caption, img.sort_order
FROM itinerary_days id_day
JOIN packages p ON p.id = id_day.package_id
CROSS JOIN LATERAL (
  VALUES
    (1, '/images/itinerary/thailand/day1-phuket-beach.jpg',     'Phuket Beach',           1),
    (1, '/images/itinerary/thailand/day1-bangkok-temple.jpg',   'Bangkok Temple',          2),
    (2, '/images/itinerary/thailand/day2-three-beaches.jpg',    'Three Beaches Viewpoint', 1),
    (2, '/images/itinerary/thailand/day2-ganesha.jpg',          'Phuket Big Buddha Area',  2),
    (3, '/images/itinerary/thailand/day3-phi-phi.jpg',          'Phi Phi Island',          1),
    (3, '/images/itinerary/thailand/day3-maya-bay.jpg',         'Maya Bay',                2),
    (5, '/images/itinerary/thailand/day5-coral-island.jpg',     'Coral Island',            1),
    (5, '/images/itinerary/thailand/day5-alcazar.jpg',          'Alcazar Show',            2),
    (6, '/images/itinerary/thailand/day6-sea-life.jpg',         'SEA Life Bangkok',        1),
    (6, '/images/itinerary/thailand/day6-tussaud.jpg',          'Madame Tussaud Bangkok',  2),
    (7, '/images/itinerary/thailand/day7-safari-world.jpg',     'Safari World',            1),
    (7, '/images/itinerary/thailand/day7-marine-park.jpg',      'Marine Park Show',        2)
) AS img(day_num, image_url, caption, sort_order)
WHERE p.slug = 'fascinating-thailand-tour-packages'
  AND id_day.day_number = img.day_num;


-- =============================================================================
-- SECTION 18 — HOTELS (Master catalogue)
-- Screenshot Hotels tab: "Ramada D'ma Bangkok" — 4 Stars
-- Address: 1091/388 New Petchburi Road, Soi 33 Makkasan/Pathumwan Bangkok - 10400, Thailand
-- Note: UI shows this hotel under "Day 1-3 Phuket" which appears to be
--       display test data — hotel is geographically in Bangkok.
-- Adding representative hotels for each city and star tier.
-- =============================================================================
INSERT INTO hotels (name, slug, destination_id, address, star_rating, image_url)
SELECT h.name, h.slug, d.id, h.address, h.star_rating, h.image_url
FROM (VALUES
  -- Bangkok hotels
  ('Ramada D''ma Bangkok',          'ramada-dma-bangkok',          'bangkok',
   '1091/388 New Petchburi Road, Soi 33 Makkasan, Pathumwan, Bangkok 10400, Thailand',
   4, '/images/hotels/ramada-dma-bangkok.jpg'),

  ('Centara Grand Bangkok',         'centara-grand-bangkok',       'bangkok',
   '999/99 Rama I Road, Pathumwan, Bangkok 10330, Thailand',
   5, '/images/hotels/centara-grand-bangkok.jpg'),

  ('ibis Bangkok Riverside',        'ibis-bangkok-riverside',      'bangkok',
   '27 Charoen Nakhon Road, Khlong San, Bangkok 10600, Thailand',
   3, '/images/hotels/ibis-bangkok-riverside.jpg'),

  -- Phuket hotels
  ('Amari Phuket',                  'amari-phuket',                'phuket',
   '2 Meun-Ngern Road, Patong Beach, Phuket 83150, Thailand',
   5, '/images/hotels/amari-phuket.jpg'),

  ('Holiday Inn Phuket',            'holiday-inn-phuket',          'phuket',
   '52 Thaweewong Road, Patong Beach, Phuket 83150, Thailand',
   4, '/images/hotels/holiday-inn-phuket.jpg'),

  ('ibis Phuket Patong',            'ibis-phuket-patong',          'phuket',
   '83 Rat-U-Thit 200 Pi Road, Patong Beach, Phuket 83150, Thailand',
   3, '/images/hotels/ibis-phuket-patong.jpg'),

  -- Pattaya hotels
  ('Dusit Thani Pattaya',           'dusit-thani-pattaya',         'pattaya',
   '240/2 Beach Road, Pattaya City, Chon Buri 20150, Thailand',
   5, '/images/hotels/dusit-thani-pattaya.jpg'),

  ('Amari Pattaya',                 'amari-pattaya',               'pattaya',
   '240 Beach Road, Pattaya City, Chon Buri 20260, Thailand',
   4, '/images/hotels/amari-pattaya.jpg'),

  ('ibis Pattaya',                  'ibis-pattaya',                'pattaya',
   '239 Beach Road, Pattaya City, Chon Buri 20150, Thailand',
   3, '/images/hotels/ibis-pattaya.jpg')

) AS h(name, slug, city_slug, address, star_rating, image_url)
JOIN destinations d ON d.slug = h.city_slug;


-- =============================================================================
-- SECTION 19 — PACKAGE HOTELS
-- Links hotels to the Thailand package by day range and star tier.
-- Screenshot: "Day 1-3 Phuket" accordion shows Ramada D'ma Bangkok (4★)
-- Full mapping: 3 cities × 3 star tiers = 9 rows
-- =============================================================================
INSERT INTO package_hotels
  (package_id, hotel_id, destination_id, hotel_star_rating, day_from, day_to, sort_order)
SELECT p.id, h.id, dest.id, ph.hotel_star_rating, ph.day_from, ph.day_to, ph.sort_order
FROM packages p
CROSS JOIN (VALUES
  -- Phuket: Days 1–3
  ('phuket', 'amari-phuket',         5, 1, 3, 1),
  ('phuket', 'holiday-inn-phuket',   4, 1, 3, 2),
  ('phuket', 'ibis-phuket-patong',   3, 1, 3, 3),
  -- Pattaya: Days 4–5
  ('pattaya','dusit-thani-pattaya',  5, 4, 5, 4),
  ('pattaya','amari-pattaya',        4, 4, 5, 5),
  ('pattaya','ibis-pattaya',         3, 4, 5, 6),
  -- Bangkok: Days 6–7 (check out day 8)
  ('bangkok','centara-grand-bangkok',5, 6, 7, 7),
  ('bangkok','ramada-dma-bangkok',   4, 6, 7, 8),
  ('bangkok','ibis-bangkok-riverside',3,6, 7, 9)
) AS ph(dest_slug, hotel_slug, hotel_star_rating, day_from, day_to, sort_order)
JOIN hotels h ON h.slug = ph.hotel_slug
JOIN destinations dest ON dest.slug = ph.dest_slug
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 20 — PACKAGE INCLUSIONS
-- Screenshot: "What's included" tab — all checklist items visible
-- =============================================================================
INSERT INTO package_inclusions (package_id, inclusion_text, sort_order)
SELECT p.id, inc.inclusion_text, inc.sort_order
FROM packages p
CROSS JOIN (VALUES
  ('3 nights'' accommodation in Phuket',                        1),
  ('2 nights'' accommodation in Bangkok',                        2),
  ('Phi Phi island tour by Big Boat',                            3),
  ('Bangkok city tour',                                          4),
  ('SAFARI WORLD WITH MARINE',                                   5),
  ('CORAL ISLAND TOUR',                                          6),
  ('Phuket airport to Phuket Hotel on PVT basis',               7),
  ('Bangkok airport to Pattaya Hotel on PVT basis',             8),
  ('Bangkok Hotel to Bangkok Airport on PVT basis',             9),
  ('All Tours are on SIC basis',                                10),
  ('2 nights'' accommodation in Pattaya',                        11),
  ('Daily breakfast (Except on day 1)',                         12),
  ('Phuket city tour',                                          13),
  ('SEA LIFE & Madame Tussaud',                                 14),
  ('PARK',                                                      15),
  ('ALCAZAR SHOW',                                              16),
  ('Phuket hotel to Phuket Airport on PVT basis',               17),
  ('Pattaya Hotel to Bangkok Hotel on PVT basis',               18),
  ('Toll Taxes & Service charges',                              19),
  ('GST',                                                       20)
) AS inc(inclusion_text, sort_order)
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 21 — PACKAGE EXCLUSIONS
-- Screenshot: "What's not" tab visible but items not expanded in screenshots.
-- Adding standard exclusions typical for this package type.
-- =============================================================================
INSERT INTO package_exclusions (package_id, exclusion_text, sort_order)
SELECT p.id, exc.exclusion_text, exc.sort_order
FROM packages p
CROSS JOIN (VALUES
  ('International airfare (India to Thailand and back)',         1),
  ('Thailand visa fees',                                         2),
  ('Travel insurance',                                           3),
  ('Personal expenses such as tips, laundry, telephone calls',   4),
  ('Any meals not mentioned in inclusions',                      5),
  ('Any activity not mentioned in the itinerary',               6),
  ('Early check-in or late check-out charges',                   7),
  ('Anything not specifically mentioned under inclusions',       8)
) AS exc(exclusion_text, sort_order)
WHERE p.slug = 'fascinating-thailand-tour-packages';


-- =============================================================================
-- SECTION 22 — FAQs
-- Screenshot: "FAQs for Thailand" accordion — 5 questions visible
-- Scoped to country (country_id), not to a specific package.
-- =============================================================================
INSERT INTO faqs (country_id, question, answer, sort_order)
SELECT c.id, faq.question, faq.answer, faq.sort_order
FROM countries c
CROSS JOIN (VALUES
  (
    'How much is an 8 days trip to Thailand?',
    'An 8-day trip to Thailand typically costs between ₹25,000 to ₹45,000 per person on twin sharing, depending on your choice of hotels (3★, 4★, or 5★). This generally includes accommodation, daily breakfast, transfers, and the key tours. International airfare is usually additional.',
    1
  ),
  (
    'How many days are enough to visit Thailand?',
    'A minimum of 7 to 8 days is recommended to comfortably cover the top destinations — Phuket, Pattaya, and Bangkok. If you also want to explore Chiang Mai or Koh Samui, plan for 10 to 12 days.',
    2
  ),
  (
    'Which are the best restaurants in Pattaya?',
    'Some of the best restaurants in Pattaya include Mantra Restaurant & Bar (fine dining with multiple cuisines), Moom Aroi (authentic Thai seafood by the sea), Bruno''s Restaurant (European and Thai fusion), and The Grill House (great steaks and BBQ). Pattaya''s Walking Street also has a wide variety of street food and casual dining options.',
    3
  ),
  (
    'How is the nightlife in Bangkok and which are the best nightclubs in Bangkok?',
    'Bangkok has one of the most vibrant nightlife scenes in Asia. Top nightclubs include Levels Club & Lounge in Sukhumvit, Sing Sing Theater for a unique experience, Demo Bangkok, and the rooftop bars like Octave Rooftop Lounge. The Khao San Road area is popular for backpackers while the Silom and Sukhumvit areas cater to upscale nightlife.',
    4
  ),
  (
    'How is the nightlife in Phuket? What are the best nightclubs in Phuket?',
    'Phuket''s nightlife is centred around Patong Beach, particularly Bangla Road — one of the most famous nightlife streets in all of Asia. Top clubs include Illuzion Phuket, Seduction Beach Club, and Tiger Entertainment Complex. The beach clubs at Surin and Kamala offer a more laid-back evening experience.',
    5
  )
) AS faq(question, answer, sort_order)
WHERE c.slug = 'thailand';


-- =============================================================================
-- SECTION 23 — HOMEPAGE PACKAGE CARDS (starting prices for country cards)
-- The homepage cards for Bestseller International show:
--   Dubai: ₹13,000 | Maldives: ₹33,000 | Sri Lanka: ₹23,000
-- The homepage cards for Popular Domestic show:
--   Andaman: ₹13,000 | Goa: ₹33,000 | Kerala: ₹23,000
--   Himachal: ₹33,000 | Sikkim-Gangtok-Darjeeling: ₹13,000 | Kashmir: ₹23,000
-- These are placeholder packages — slugs and minimal data only.
-- Full itinerary, hotels, and images to be added later.
-- =============================================================================
INSERT INTO packages
  (title, slug, country_id, duration_days, duration_nights,
   short_description, starting_price, best_time_to_visit,
   is_bestseller, is_domestic)
SELECT
  c.pkg_title, c.pkg_slug, co.id,
  c.duration_days, c.duration_nights,
  c.short_description,
  c.starting_price,
  'Jul - Apr',
  c.is_bestseller,
  c.is_domestic
FROM (VALUES
  -- International Bestsellers
  ('dubai',     'dubai-tour-packages',         'Dubai Tour Packages — Desert, Malls & Skyline',
   6, 5, 'Explore the best of Dubai — Burj Khalifa, Desert Safari, Dubai Mall and more.',
   13000.00, true, false),

  ('maldives',  'maldives-tour-packages',       'Maldives Tour Packages — Paradise Islands',
   5, 4, 'Experience the pristine beaches, overwater bungalows and crystal clear lagoons of Maldives.',
   33000.00, true, false),

  ('sri-lanka', 'sri-lanka-tour-packages',      'Sri Lanka Tour Packages — Pearl of the Indian Ocean',
   6, 5, 'Discover ancient temples, lush tea gardens, beaches and wildlife in beautiful Sri Lanka.',
   23000.00, true, false),

  -- Popular Domestic
  ('andaman',   'andaman-tour-packages',        'Andaman Tour Packages — Islands & Beaches',
   5, 4, 'Explore the stunning beaches, coral reefs, and Cellular Jail of the Andaman Islands.',
   13000.00, false, true),

  ('goa',       'goa-tour-packages',            'Goa Tour Packages — Beaches, Churches & Nightlife',
   4, 3, 'Experience the best of Goa — beautiful beaches, historic churches, and vibrant nightlife.',
   33000.00, false, true),

  ('kerala',    'kerala-tour-packages',         'Kerala Tour Packages — God''s Own Country',
   6, 5, 'Explore Kerala''s backwaters, houseboat stays, hill stations, and Ayurvedic wellness.',
   23000.00, false, true),

  ('himachal',  'himachal-tour-packages',       'Himachal Tour Packages — Mountains & Valleys',
   6, 5, 'Discover the snow-capped peaks, apple orchards, and adventure activities of Himachal Pradesh.',
   33000.00, false, true),

  ('sikkim-gangtok-darjeeling', 'sikkim-gangtok-darjeeling-tour-packages',
   'Sikkim Gangtok Darjeeling Tour Packages',
   7, 6, 'Explore the scenic beauty of Gangtok, Darjeeling tea gardens and the mighty Himalayas.',
   13000.00, false, true),

  ('kashmir',   'kashmir-tour-packages',        'Kashmir Tour Packages — Paradise on Earth',
   6, 5, 'Experience the breathtaking beauty of Dal Lake, Gulmarg, Pahalgam and Sonamarg.',
   23000.00, false, true)

) AS c(country_slug, pkg_slug, pkg_title, duration_days, duration_nights,
       short_description, starting_price, is_bestseller, is_domestic)
JOIN countries co ON co.slug = c.country_slug;

COMMIT;
