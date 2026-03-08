import type { SyncMeta, SyncType } from '~/domain/sync/types'

const syncMetaStorage = () => useStorage<SyncMeta>('sync-meta')

export const syncMetaRepository = {
  findByType: async (type: SyncType) => {
    return await syncMetaStorage().getItem(type)
  },

  save: async (meta: SyncMeta) => {
    await syncMetaStorage().setItem(meta.type, meta)
  },
}
