import { ensureDB, saveDB } from '../src/storage.js';

(async () => {
  const db = await ensureDB(true);
  await saveDB(db);
  console.log('[reset] database reset to seed');
})();