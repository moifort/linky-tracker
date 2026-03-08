import { MonthlyTrendsReadModel } from '~/read-model/analytics/monthly-trends'

export default defineEventHandler(async (event) => {
  const { months = '12' } = getQuery(event) as { months?: string }
  const data = await MonthlyTrendsReadModel.compare(Number(months))
  return { status: 200, data }
})
