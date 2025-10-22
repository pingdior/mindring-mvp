import fs from 'fs/promises';
import path from 'path';

const root = path.resolve(process.cwd(), 'data');
const dbPath = path.join(root, 'db.json');

export async function ensureDB(reset = false) {
  await fs.mkdir(root, { recursive: true });
  if (reset) {
    await fs.writeFile(dbPath, JSON.stringify(seed(), null, 2), 'utf-8');
    return seed();
  }
  try {
    const buf = await fs.readFile(dbPath, 'utf-8');
    return JSON.parse(buf);
  } catch {
    const s = seed();
    await fs.writeFile(dbPath, JSON.stringify(s, null, 2), 'utf-8');
    return s;
  }
}

export async function loadDB() {
  try {
    const buf = await fs.readFile(dbPath, 'utf-8');
    return JSON.parse(buf);
  } catch {
    return await ensureDB(false);
  }
}

export async function saveDB(db) {
  await fs.writeFile(dbPath, JSON.stringify(db, null, 2), 'utf-8');
}

export function seed() {
  const now = new Date();
  const ts = now.toISOString();
  const yesterday = new Date(Date.now() - 24 * 3600 * 1000).toISOString();
  return {
    users: [{ id: 'u1', locale: 'en-US', createdAt: ts }],
    sessions: [
      {
        id: 's1',
        timestamp: ts,
        source: 'ring',
        title: 'Sprint Alignment',
        summary: 'Confirmed rhythm, surfaced data gap.',
        emotions: [],
        tags: ['Self‑Awareness', 'Energized + Wary']
      },
      {
        id: 's0',
        timestamp: yesterday,
        source: 'alex',
        title: 'Alex Follow-up',
        summary: 'Named blind spots, emotion shifts tracked.',
        emotions: [],
        tags: ['Curious', 'Focused']
      }
    ],
    emotions: [
      { id: 'e1', timestamp: ts, labels: ['Curious', 'Wary'], granularityScore: 0 },
      { id: 'e0', timestamp: yesterday, labels: ['Focused'], granularityScore: 0 }
    ],
    reflections: [
      { id: 'r1', date: ts.slice(0, 10), status: 'pending', notes: '' }
    ],
    scoreSnapshots: []
  };
}