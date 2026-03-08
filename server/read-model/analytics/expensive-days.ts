import { sortBy } from 'lodash-es'
import { ConsumptionQuery } from '~/domain/consumption/query'
import { dailyCost } from '~/domain/pricing/business-rules'
import { PricingQuery } from '~/domain/pricing/query'

export const ExpensiveDaysReadModel = {
  topDays: async (count: number, start: Date, end: Date) => {
    const config = await PricingQuery.currentConfig()
    const dailyData = await ConsumptionQuery.dailyByRange(start, end)

    if (!config || dailyData.length === 0) return []

    const hcRatio = 0.4
    const daysWithCost = dailyData.map((day) => {
      const kwh = (day.totalWh as number) / 1000
      const cost = dailyCost(kwh as never, config.hpRate, config.hcRate, hcRatio)
      return {
        date: day.date,
        kwh: Math.round(kwh * 100) / 100,
        costEur: Math.round(cost * 100) / 100,
      }
    })

    return sortBy(daysWithCost, ({ costEur }) => -costEur).slice(0, count)
  },
}
