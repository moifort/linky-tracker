import { SyncCommand } from '~/domain/sync/command'
import { createLogger } from '~/system/logger'

const logger = createLogger('task:sync:max-power')

export default defineTask({
  meta: { name: 'sync:max-power', description: 'Sync max power from Enedis' },
  run: async () => {
    logger.info('Running max power sync task')
    const result = await SyncCommand.syncMaxPower()
    logger.info(`Task complete: ${result.outcome}`)
    return { result }
  },
})
