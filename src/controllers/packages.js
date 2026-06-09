const q = require('../queries/packages');

// GET /api/packages/:slug
// Returns the package header data + cities + amenities in one shot.
const getPackage = async (req, res, next) => {
  try {
    const { rows } = await q.getPackageBySlug(req.params.slug);
    if (!rows.length) return res.status(404).json({ error: 'Package not found' });
    res.json(rows[0]);
  } catch (err) {
    next(err);
  }
};

// GET /api/packages/:slug/images
const getImages = async (req, res, next) => {
  try {
    const pkg = await q.getPackageBySlug(req.params.slug);
    if (!pkg.rows.length) return res.status(404).json({ error: 'Package not found' });

    const { rows } = await q.getPackageImages(pkg.rows[0].id);
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

// GET /api/packages/:slug/pricing
const getPricing = async (req, res, next) => {
  try {
    const pkg = await q.getPackageBySlug(req.params.slug);
    if (!pkg.rows.length) return res.status(404).json({ error: 'Package not found' });

    const { rows } = await q.getPackagePricing(pkg.rows[0].id);
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

// GET /api/packages/:slug/highlights
const getHighlights = async (req, res, next) => {
  try {
    const pkg = await q.getPackageBySlug(req.params.slug);
    if (!pkg.rows.length) return res.status(404).json({ error: 'Package not found' });

    const { rows } = await q.getPackageHighlights(pkg.rows[0].id);
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

// GET /api/packages/:slug/itinerary
const getItinerary = async (req, res, next) => {
  try {
    const pkg = await q.getPackageBySlug(req.params.slug);
    if (!pkg.rows.length) return res.status(404).json({ error: 'Package not found' });

    const { rows } = await q.getPackageItinerary(pkg.rows[0].id);
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

// GET /api/packages/:slug/hotels?stars=4
const getHotels = async (req, res, next) => {
  try {
    const stars = parseInt(req.query.stars, 10);
    if (![3, 4, 5].includes(stars)) {
      return res.status(400).json({ error: 'stars must be 3, 4, or 5' });
    }

    const pkg = await q.getPackageBySlug(req.params.slug);
    if (!pkg.rows.length) return res.status(404).json({ error: 'Package not found' });

    const { rows } = await q.getPackageHotels(pkg.rows[0].id, stars);
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

// GET /api/packages/:slug/inclusions
const getInclusions = async (req, res, next) => {
  try {
    const pkg = await q.getPackageBySlug(req.params.slug);
    if (!pkg.rows.length) return res.status(404).json({ error: 'Package not found' });

    const [included, excluded] = await Promise.all([
      q.getPackageInclusions(pkg.rows[0].id),
      q.getPackageExclusions(pkg.rows[0].id),
    ]);

    res.json({
      included: included.rows,
      excluded: excluded.rows,
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getPackage,
  getImages,
  getPricing,
  getHighlights,
  getItinerary,
  getHotels,
  getInclusions,
};
