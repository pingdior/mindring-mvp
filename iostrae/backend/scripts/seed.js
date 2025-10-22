import { ensureDB, saveDB, seed } from '../src/storage.js';

(async () => {
  const db = seed();
  await saveDB(db);
  console.log('[seed] database initialized with sample data');
})();