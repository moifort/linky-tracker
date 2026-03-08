import { ConsumptionCommand } from '~/domain/consumption/command'
import { ConsoApi } from '~/domain/consumption/conso.api'
import { syncMetaRepository } from '~/domain/sync/repository'
import type { SyncMeta } from '~/domain/sync/types'
import { createLogger } from '~/system/logger'

const logger = createLogger('sync')

const config = () => useRuntimeConfig()

const formatDate = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`

const defaultStartDate = () => {
  const date = new Date()
  date.setFullYear(date.getFullYear() - 3)
  return date
}

const yesterday = () => {
  const date = new Date()
  date.setDate(date.getDate() - 1)
  return date
}

const daysAgo = (days: number) => {
  const date = new Date()
  date.setDate(date.getDate() - days)
  return date
}

export const SyncCommand = {
  syncDailyConsumption: async () => {
    const { consoApiToken, consoApiPrm } = config()
    const meta = await syncMetaRepository.findByType('daily-consumption')
    const start = meta ? new Date(meta.lastSyncedDate) : defaultStartDate()
    const end = yesterday()

    if (start >= end) {
      logger.info('Daily consumption already up to date')
      return { outcome: 'up-to-date' } as const
    }

    const readings = await ConsoApi.fetchDailyConsumption(consoApiToken, consoApiPrm, start, end)
    const result = await ConsumptionCommand.syncDaily(readings)

    const updatedMeta: SyncMeta = {
      type: 'daily-consumption',
      lastSyncedDate: formatDate(end),
      lastSyncedAt: new Date(),
    }
    await syncMetaRepository.save(updatedMeta)
    logger.info(`Synced ${result.count} daily consumption records`)
    return { outcome: 'synced', count: result.count } as const
  },

  syncLoadCurve: async () => {
    const { consoApiToken, consoApiPrm } = config()
    const start = daysAgo(7)
    const end = yesterday()

    const readings = await ConsoApi.fetchLoadCurve(consoApiToken, consoApiPrm, start, end)
    const result = await ConsumptionCommand.syncLoadCurve(readings)

    const updatedMeta: SyncMeta = {
      type: 'load-curve',
      lastSyncedDate: formatDate(end),
      lastSyncedAt: new Date(),
    }
    await syncMetaRepository.save(updatedMeta)
    logger.info(`Synced ${result.count} load curve records`)
    return { outcome: 'synced', count: result.count } as const
  },

  syncMaxPower: async () => {
    const { consoApiToken, consoApiPrm } = config()
    const meta = await syncMetaRepository.findByType('max-power')
    const start = meta ? new Date(meta.lastSyncedDate) : defaultStartDate()
    const end = yesterday()

    if (start >= end) {
      logger.info('Max power already up to date')
      return { outcome: 'up-to-date' } as const
    }

    const readings = await ConsoApi.fetchMaxPower(consoApiToken, consoApiPrm, start, end)
    const result = await ConsumptionCommand.syncMaxPower(readings)

    const updatedMeta: SyncMeta = {
      type: 'max-power',
      lastSyncedDate: formatDate(end),
      lastSyncedAt: new Date(),
    }
    await syncMetaRepository.save(updatedMeta)
    logger.info(`Synced ${result.count} max power records`)
    return { outcome: 'synced', count: result.count } as const
  },
}
