import express from 'express';
import cors from 'cors';
import { v4 as uuidv4 } from 'uuid';
import { loadDB, saveDB, ensureDB } from './storage.js';
import { computeSnapshot, generateAdvice, nowISO } from './scoring.js';

const app = express();
const PORT = process.env.PORT || 8001;

app.use(cors());
app.use(express.json());

// Health
app.get('/health', (_req, res) => {
  res.json({ ok: true, service: 'mindring-backend', ts: new Date().toISOString() });
});

// Sessions
app.get('/sessions', async (_req, res) => {
  const db = await loadDB();
  res.json({ sessions: db.sessions });
});

// Record Save (creates a Session and triggers score update)
app.post('/record/save', async (req, res) => {
  const { title = 'Quick Capture', summary = '', source = 'recording', emotions = [], timestamp } = req.body || {};
  const db = await loadDB();
  const ts = timestamp || nowISO();
  const session = {
    id: uuidv4(),
    timestamp: ts,
    source,
    title,
    summary,
    emotions: emotions.map(labels => ({ id: uuidv4(), timestamp: ts, labels, granularityScore: 0 })),
    tags: ['Self‑Awareness', 'New']
  };
  db.sessions.unshift(session);

  // Also log emotion entries if provided
  for (const e of session.emotions) {
    db.emotions.unshift(e);
  }

  // Recompute snapshot
  const snapshot = computeSnapshot(db);
  db.scoreSnapshots.unshift(snapshot);

  await saveDB(db);
  res.json({ session, snapshot });
});

// Emotion log
app.post('/emotion/log', async (req, res) => {
  const { labels = [], timestamp } = req.body || {};
  const ts = timestamp || nowISO();
  const db = await loadDB();
  const entry = { id: uuidv4(), timestamp: ts, labels, granularityScore: 0 };
  db.emotions.unshift(entry);

  const snapshot = computeSnapshot(db);
  db.scoreSnapshots.unshift(snapshot);
  await saveDB(db);
  res.json({ emotion: entry, snapshot });
});

// Reflection complete
app.post('/reflection/complete', async (req, res) => {
  const { notes = '', date } = req.body || {};
  const d = date || new Date().toISOString().slice(0, 10);
  const db = await loadDB();

  const rec = { id: uuidv4(), date: d, status: 'completed', notes };
  // Replace existing record for the date if exists
  db.reflections = db.reflections.filter(r => r.date !== d);
  db.reflections.unshift(rec);

  const snapshot = computeSnapshot(db);
  db.scoreSnapshots.unshift(snapshot);
  await saveDB(db);
  res.json({ reflection: rec, snapshot });
});

// Score snapshot (latest)
app.get('/score/snapshot', async (_req, res) => {
  const db = await loadDB();
  const latest = db.scoreSnapshots[0] || computeSnapshot(db);
  const advice = generateAdvice(latest);
  res.json({ snapshot: latest, advice });
});

// Advice explicit
app.get('/advice/today', async (_req, res) => {
  const db = await loadDB();
  const latest = db.scoreSnapshots[0] || computeSnapshot(db);
  res.json(generateAdvice(latest));
});

// Seed data (dev only)
app.post('/dev/seed', async (_req, res) => {
  const db = await ensureDB(true);
  await saveDB(db);
  res.json({ ok: true });
});

app.listen(PORT, async () => {
  await ensureDB(false);
  console.log(`[mindring-backend] listening on http://localhost:${PORT}`);
});