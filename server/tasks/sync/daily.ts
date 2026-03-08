import { SyncCommand } from '~/domain/sync/command'
import { createLogger } from '~/system/logger'

const logger = createLogger('task:sync:daily')

export default defineTask({
  meta: { name: 'sync:daily', description: 'Sync daily consumption from Enedis' },
  run: async () => {
    logger.info('Running daily consumption sync task')
    const result = await SyncCommand.syncDailyConsumption()
    logger.info(`Task complete: ${result.outcome}`)
    return { result }
  },
})
