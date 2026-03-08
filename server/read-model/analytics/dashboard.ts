import { ConsumptionQuery } from '~/domain/consumption/query'
import { dailyCost, projectedMonthlyCost } from '~/domain/pricing/business-rules'
import { PricingQuery } from '~/domain/pricing/query'

const startOfMonth = (date: Date) => new Date(date.getFullYear(), date.getMonth(), 1)
const endOfMonth = (date: Date) => new Date(date.getFullYear(), date.getMonth() + 1, 0)
const daysInMonth = (date: Date) => new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate()

export const DashboardReadModel = {
  currentMonth: async () => {
    const now = new Date()
    const start = startOfMonth(now)
    const end = endOfMonth(now)

    const dailyData = await ConsumptionQuery.dailyByRange(start, end)
    const config = await PricingQuery.currentConfig()

    const totalKwh = dailyData.reduce((sum, day) => sum + (day.totalWh as number) / 1000, 0)
    const daysWithData = dailyData.length
    const averageDailyKwh = daysWithData > 0 ? totalKwh / daysWithData : 0

    let estimatedCostEur = 0
    let previousMonthEvolutionPercent: number | null = null

    if (config) {
      const hcRatio = 0.4
      const dailyCosts = dailyData.map((day) =>
        dailyCost(((day.totalWh as number) / 1000) as never, config.hpRate, config.hcRate, hcRatio),
      )
      estimatedCostEur = projectedMonthlyCost(
        dailyCosts,
        daysInMonth(now),
        config.subscriptionMonthlyEur as number,
      )

      const prevStart = new Date(now.getFullYear(), now.getMonth() - 1, 1)
      const prevEnd = new Date(now.getFullYear(), now.getMonth(), 0)
      const prevData = await ConsumptionQuery.dailyByRange(prevStart, prevEnd)
      const prevTotalKwh = prevData.reduce((sum, day) => sum + (day.totalWh as number) / 1000, 0)

      if (prevTotalKwh > 0 && daysWithData > 0) {
        const projectedTotalKwh = averageDailyKwh * daysInMonth(now)
        previousMonthEvolutionPercent = ((projectedTotalKwh - prevTotalKwh) / prevTotalKwh) * 100
      }
    }

    return {
      totalKwh: Math.round(totalKwh * 100) / 100,
      averageDailyKwh: Math.round(averageDailyKwh * 100) / 100,
      estimatedCostEur: Math.round(estimatedCostEur * 100) / 100,
      previousMonthEvolutionPercent:
        previousMonthEvolutionPercent !== null
          ? Math.round(previousMonthEvolutionPercent * 10) / 10
          : null,
      daysWithData,
    }
  },
}
