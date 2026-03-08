import { ConsumptionQuery } from '~/domain/consumption/query'

export default defineEventHandler(async (event) => {
  const { start, end } = getQuery(event) as { start: string; end: string }
  const data = await ConsumptionQuery.dailyByRange(new Date(start), new Date(end))
  return { status: 200, data }
})
