// Scoring aligned with PRD 0.2
// EG (40%), RC (40%), EMA (20%)

const SPECIFIC_WORDS = new Set([
  'Wary', 'Focused', 'Grateful', 'Stressed', 'Calm', 'Excited', 'Curious'
]);

function clamp(x, lo = 0, hi = 1) { return Math.max(lo, Math.min(hi, x)); }
export function nowISO() { return new Date().toISOString(); }

export function computeSnapshot(db) {
  const now = new Date();
  const windowStart = new Date(Date.now() - 24 * 3600 * 1000);
  const emotions24h = db.emotions.filter(e => new Date(e.timestamp) >= windowStart);

  const N = emotions24h.length;
  let K = 0; // specific or composite
  let compositeCount = 0;
  for (const e of emotions24h) {
    const isComposite = Array.isArray(e.labels) && e.labels.length >= 2;
    const isSpecific = e.labels.some(l => SPECIFIC_WORDS.has(String(l)));
    if (isComposite || isSpecific) K += 1;
    if (isComposite) compositeCount += 1;
  }
  const EG_base = clamp(N === 0 ? 0 : K / Math.max(1, Math.min(3, N)));
  const specificityBoost = clamp(0.1 * Math.min(2, compositeCount), 0, 0.2);
  const EG = clamp(EG_base + specificityBoost);

  const todayISO = now.toISOString().slice(0, 10);
  const todayReflection = db.reflections.find(r => r.date === todayISO && r.status === 'completed');
  const RC = todayReflection ? 1 : 0;

  const S_t = 0.5 * EG + 0.5 * RC;
  const prevEMA = db.scoreSnapshots[0]?.components?.consistencyEMA ?? undefined;
  const alpha = 0.3;
  const EMA = prevEMA === undefined ? S_t : alpha * S_t + (1 - alpha) * prevEMA;

  const score = Math.round(100 * (0.4 * EG + 0.4 * RC + 0.2 * EMA));
  return {
    timestamp: now.toISOString(),
    selfAwareness: score,
    components: {
      emotionGranularity: Number(EG.toFixed(2)),
      reflectionCompletion: Number(RC.toFixed(2)),
      consistencyEMA: Number(EMA.toFixed(2))
    }
  };
}

export function generateAdvice(snapshot) {
  const { emotionGranularity: EG, reflectionCompletion: RC, consistencyEMA: EMA } = snapshot.components;
  const chips = [];
  if (EG < 0.5) chips.push('Write one composite emotion (e.g., “Curious + Wary”).');
  if (RC < 1.0) chips.push('Complete Today’s Deep Dive and name premise + concern.');
  if (EMA < 0.6) chips.push('Keep daily logs for 3 consecutive days to stabilize score.');
  if (chips.length === 0) chips.push('Refine triggers and update your personal emotion vocabulary.');
  return { id: 'adv_' + Date.now(), date: new Date().toISOString().slice(0, 10), chips };
}