import { SyncCommand } from '~/domain/sync/command'
import { createLogger } from '~/system/logger'

const logger = createLogger('task:sync:load-curve')

export default defineTask({
  meta: { name: 'sync:load-curve', description: 'Sync load curve from Enedis' },
  run: async () => {
    logger.info('Running load curve sync task')
    const result = await SyncCommand.syncLoadCurve()
    logger.info(`Task complete: ${result.outcome}`)
    return { result }
  },
})
