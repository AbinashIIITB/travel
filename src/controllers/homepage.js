const q = require('../queries/homepage');

const getRegions = async (req, res, next) => {
  try {
    const { rows } = await q.getRegions();
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

const getThemes = async (req, res, next) => {
  try {
    const { rows } = await q.getThemes();
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

const getBudgetCategories = async (req, res, next) => {
  try {
    const { rows } = await q.getBudgetCategories();
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

const getInternationalCountries = async (req, res, next) => {
  try {
    const { rows } = await q.getInternationalCountries();
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

const getDomesticCountries = async (req, res, next) => {
  try {
    const { rows } = await q.getDomesticCountries();
    res.json(rows);
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getRegions,
  getThemes,
  getBudgetCategories,
  getInternationalCountries,
  getDomesticCountries,
};
