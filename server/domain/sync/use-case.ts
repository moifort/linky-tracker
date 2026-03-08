import { SyncCommand } from '~/domain/sync/command'
import { createLogger } from '~/system/logger'

const logger = createLogger('sync-use-case')

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

export const SyncUseCase = {
  fullSync: async () => {
    logger.info('Starting full sync')

    const dailyResult = await SyncCommand.syncDailyConsumption()
    await delay(250)

    const maxPowerResult = await SyncCommand.syncMaxPower()
    await delay(250)

    const loadCurveResult = await SyncCommand.syncLoadCurve()

    logger.info('Full sync complete')
    return {
      outcome: 'completed',
      daily: dailyResult,
      maxPower: maxPowerResult,
      loadCurve: loadCurveResult,
    } as const
  },
}
