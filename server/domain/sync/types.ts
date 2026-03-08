export type SyncType = 'daily-consumption' | 'load-curve' | 'max-power'

export type SyncMeta = {
  type: SyncType
  lastSyncedDate: string
  lastSyncedAt: Date
}
