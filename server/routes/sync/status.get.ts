import { syncMetaRepository } from '~/domain/sync/repository'
import type { SyncType } from '~/domain/sync/types'

export default defineEventHandler(async () => {
  const types: SyncType[] = ['daily-consumption', 'load-curve', 'max-power']
  const statuses = await Promise.all(
    types.map(async (type) => {
      const meta = await syncMetaRepository.findByType(type)
      return {
        type,
        lastSyncedDate: meta?.lastSyncedDate ?? null,
        lastSyncedAt: meta?.lastSyncedAt ?? null,
      }
    }),
  )
  return { status: 200, data: statuses }
})
