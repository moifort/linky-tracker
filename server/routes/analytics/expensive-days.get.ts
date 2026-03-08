import { ExpensiveDaysReadModel } from '~/read-model/analytics/expensive-days'

export default defineEventHandler(async (event) => {
  const {
    start,
    end,
    count = '10',
  } = getQuery(event) as {
    start: string
    end: string
    count?: string
  }
  const data = await ExpensiveDaysReadModel.topDays(Number(count), new Date(start), new Date(end))
  return { status: 200, data }
})
