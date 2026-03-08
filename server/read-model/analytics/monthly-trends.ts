import { ConsumptionQuery } from '~/domain/consumption/query'
import { dailyCost } from '~/domain/pricing/business-rules'
import { PricingQuery } from '~/domain/pricing/query'

export const MonthlyTrendsReadModel = {
  compare: async (months: number) => {
    const config = await PricingQuery.currentConfig()
    const now = new Date()
    const results: {
      month: string
      totalKwh: number
      averageDailyKwh: number
      estimatedCostEur: number
      evolutionPercent: number | null
    }[] = []

    let previousTotalKwh: number | null = null

    for (let i = months - 1; i >= 0; i--) {
      const start = new Date(now.getFullYear(), now.getMonth() - i, 1)
      const end = new Date(now.getFullYear(), now.getMonth() - i + 1, 0)
      const daysInMonth = end.getDate()

      const dailyData = await ConsumptionQuery.dailyByRange(start, end)
      const totalKwh = dailyData.reduce((sum, day) => sum + (day.totalWh as number) / 1000, 0)
      const averageDailyKwh = dailyData.length > 0 ? totalKwh / dailyData.length : 0

      let estimatedCostEur = 0
      if (config) {
        const hcRatio = 0.4
        const dailyCosts = dailyData.map((day) =>
          dailyCost(
            ((day.totalWh as number) / 1000) as never,
            config.hpRate,
            config.hcRate,
            hcRatio,
          ),
        )
        const avgDailyCost =
          dailyCosts.length > 0 ? dailyCosts.reduce((s, c) => s + c, 0) / dailyCosts.length : 0
        estimatedCostEur = avgDailyCost * daysInMonth + (config.subscriptionMonthlyEur as number)
      }

      const evolutionPercent =
        previousTotalKwh !== null && previousTotalKwh > 0
          ? ((totalKwh - previousTotalKwh) / previousTotalKwh) * 100
          : null

      const monthLabel = `${start.getFullYear()}-${String(start.getMonth() + 1).padStart(2, '0')}`

      results.push({
        month: monthLabel,
        totalKwh: Math.round(totalKwh * 100) / 100,
        averageDailyKwh: Math.round(averageDailyKwh * 100) / 100,
        estimatedCostEur: Math.round(estimatedCostEur * 100) / 100,
        evolutionPercent: evolutionPercent !== null ? Math.round(evolutionPercent * 10) / 10 : null,
      })

      previousTotalKwh = totalKwh
    }

    return results
  },
}
