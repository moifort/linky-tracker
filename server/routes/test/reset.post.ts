export default defineEventHandler(async () => {
  for (const name of [
    'migration-meta',
    'daily-consumption',
    'load-curve',
    'max-power',
    'pricing-config',
    'sync-meta',
  ]) {
    const storage = useStorage(name)
    const keys = await storage.getKeys()
    for (const key of keys) await storage.removeItem(key)
  }
  return { status: 200, message: 'Database reset' }
})
