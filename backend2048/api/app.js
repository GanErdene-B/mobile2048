var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var fs = require('fs');
// safe require for optional modules to avoid hard crash in containers if install step failed
let corsLib;
try {
  corsLib = require('cors');
} catch (e) {
  corsLib = null;
  console.warn('Warning: "cors" module not found. Using fallback CORS headers. Run `npm install` in backend2048/api or rebuild the docker image to install dependencies.');
}

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

// API key configuration: read from environment or use provided default token.
// Override at runtime with: API_KEY=yourkey node app.js  (or set in Docker env)
const DEFAULT_API_KEY = process.env.API_KEY || 'b959f4477271';
(function(){
  const masked = DEFAULT_API_KEY.length > 8
    ? DEFAULT_API_KEY.substring(0,4) + '...' + DEFAULT_API_KEY.substring(DEFAULT_API_KEY.length-4)
    : '***';
  console.log(`API key in use (masked): ${masked}`);
})();

// middleware to require API key for protected routes
function requireApiKey(req, res, next) {
  const keyHeader = req.headers['x-api-key'] || req.query.api_key;
  if (!keyHeader || keyHeader !== DEFAULT_API_KEY) {
    return res.status(401).json({ ok: false, error: 'Unauthorized - invalid or missing API key' });
  }
  next();
}

// enable CORS so frontend can call backend (adjust origin in production)
if (corsLib) {
  app.use(corsLib());
} else {
  // lightweight fallback CORS middleware
  app.use(function (req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, x-api-key');
    if (req.method === 'OPTIONS') {
      return res.sendStatus(200);
    }
    next();
  });
}

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// Simple disk-backed store (data.json) to keep games and leaderboard.
// File format: { "games": [...], "leaderboard": [...] }
const DATA_FILE = path.join(__dirname, 'data.json');

function loadData() {
  try {
    if (!fs.existsSync(DATA_FILE)) {
      const init = { games: [], leaderboard: [] };
      fs.writeFileSync(DATA_FILE, JSON.stringify(init, null, 2));
      return init;
    }
    const raw = fs.readFileSync(DATA_FILE, 'utf8');
    return JSON.parse(raw || '{"games":[],"leaderboard":[]}');
  } catch (e) {
    console.error('Failed to load data file:', e);
    return { games: [], leaderboard: [] };
  }
}

function saveData(data) {
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2));
  } catch (e) {
    console.error('Failed to write data file:', e);
  }
}

// POST /api/save
// Require API key for save to avoid unauthorized writes.
app.post('/api/save', requireApiKey, (req, res) => {
  const payload = req.body || {};
  const data = loadData();

  // store the game
  const gameRecord = {
    id: Date.now(),
    data: payload,
    bestScore: payload.bestScore || 0,
    undoCount: payload.undoCount || 0,
    timestamp: payload.timestamp || new Date().toISOString(),
    size: payload.size || 4
  };
  data.games.push(gameRecord);

  // optional: if payload includes player & bestScore, update leaderboard
  if (payload.player && typeof payload.bestScore === 'number') {
    data.leaderboard.push({
      id: Date.now() + 1,
      player: payload.player,
      score: payload.bestScore,
      timestamp: payload.timestamp || new Date().toISOString()
    });
    // keep only top N sorted later on read
  }

  saveData(data);
  return res.status(201).json({ ok: true, saved: gameRecord });
});

// GET /api/leaderboard
// Returns top 10 leaderboard entries sorted by score desc
app.get('/api/leaderboard', (req, res) => {
  const data = loadData();
  const list = Array.isArray(data.leaderboard) ? data.leaderboard.slice() : [];
  list.sort((a, b) => (b.score || 0) - (a.score || 0));
  const top = list.slice(0, 10);
  return res.json({ ok: true, leaderboard: top });
});

// GET /api/health
// Returns server health information
app.get('/api/health', (req, res) => {
  return res.json({ ok: true, uptime: process.uptime() });
});

// GET /api/games
// Fetch saved games (optional: add requireApiKey if needed)
app.get('/api/games', (req, res) => {
  const data = loadData();
  const games = Array.isArray(data.games) ? data.games.slice() : [];
  return res.json({ ok: true, games: games.slice(0, 50) });
});

// If this file is run directly (node app.js), start the server bound to 0.0.0.0.
// This makes the server reachable from other containers and host interfaces.
if (require.main === module) {
  const port = process.env.PORT || 3000;
  const host = '0.0.0.0';
  app.listen(port, host, () => {
    console.log(`\n========================================`);
    console.log(`Backend API listening on http://${host}:${port}`);
    console.log(`Health check:    GET http://localhost:${port}/api/health`);
    console.log(`Leaderboard:     GET http://localhost:${port}/api/leaderboard`);
    console.log(`Saved games:     GET http://localhost:${port}/api/games`);
    console.log(`Save game:       POST http://localhost:${port}/api/save (requires x-api-key header)`);
    console.log(`========================================\n`);
  });
}

module.exports = app;
