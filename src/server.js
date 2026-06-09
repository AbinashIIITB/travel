require('dotenv').config();
const express = require('express');
const cors = require('cors');

const homepageRoutes = require('./routes/homepage');
const packagesRoutes = require('./routes/packages');
const countriesRoutes = require('./routes/countries');
const quoteRoutes = require('./routes/quotes');

const app = express();

app.use(cors());
app.use(express.json());

// routes
app.use('/api/homepage', homepageRoutes);
app.use('/api/packages', packagesRoutes);
app.use('/api/countries', countriesRoutes);
app.use('/api/quotes', quoteRoutes);

// 404 — route not found
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// global error handler — keeps raw db errors away from the client
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: 'Something went wrong on our end' });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
