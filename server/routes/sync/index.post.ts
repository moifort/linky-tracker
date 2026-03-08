import { SyncUseCase } from '~/domain/sync/use-case'

export default defineEventHandler(async () => {
  const data = await SyncUseCase.fullSync()
  return { status: 200, data }
})
