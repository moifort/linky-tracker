import { HcHpDistributionReadModel } from '~/read-model/analytics/hc-hp-distribution'

export default defineEventHandler(async (event) => {
  const { start, end } = getQuery(event) as { start: string; end: string }
  const data = await HcHpDistributionReadModel.forDateRange(new Date(start), new Date(end))
  return { status: 200, data }
})
