import { DashboardReadModel } from '~/read-model/analytics/dashboard'

export default defineEventHandler(async () => {
  const data = await DashboardReadModel.currentMonth()
  return { status: 200, data }
})
