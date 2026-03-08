import { ConsumptionQuery } from '~/domain/consumption/query'
import { DashboardReadModel } from '~/read-model/analytics/dashboard'

const formatDate = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`

export const WidgetDataReadModel = {
  data: async () => {
    const now = new Date()
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    const yesterday = new Date(today)
    yesterday.setDate(yesterday.getDate() - 1)
    const weekAgo = new Date(today)
    weekAgo.setDate(weekAgo.getDate() - 7)

    const dashboard = await DashboardReadModel.currentMonth()
    const weekData = await ConsumptionQuery.dailyByRange(weekAgo, yesterday)

    const todayData = await ConsumptionQuery.dailyByRange(today, today)
    const yesterdayData = await ConsumptionQuery.dailyByRange(yesterday, yesterday)

    const todayKwh = todayData.length > 0 ? (todayData[0].totalWh as number) / 1000 : null
    const yesterdayKwh =
      yesterdayData.length > 0 ? (yesterdayData[0].totalWh as number) / 1000 : null

    const trendPercent =
      todayKwh !== null && yesterdayKwh !== null && yesterdayKwh > 0
        ? ((todayKwh - yesterdayKwh) / yesterdayKwh) * 100
        : null

    const prevMonthStart = new Date(now.getFullYear(), now.getMonth() - 1, 1)
    const prevMonthEnd = new Date(now.getFullYear(), now.getMonth(), 0)
    const prevMonthData = await ConsumptionQuery.dailyByRange(prevMonthStart, prevMonthEnd)
    const previousMonthTotalKwh = prevMonthData.reduce(
      (sum, day) => sum + (day.totalWh as number) / 1000,
      0,
    )

    return {
      todayKwh: todayKwh !== null ? Math.round(todayKwh * 100) / 100 : null,
      yesterdayKwh: yesterdayKwh !== null ? Math.round(yesterdayKwh * 100) / 100 : null,
      trendPercent: trendPercent !== null ? Math.round(trendPercent * 10) / 10 : null,
      weekData: weekData.map((day) => ({
        id: formatDate(day.date),
        date: day.date,
        kwh: Math.round(((day.totalWh as number) / 1000) * 100) / 100,
      })),
      currentMonthTotalKwh: dashboard.totalKwh,
      estimatedMonthlyCostEur: dashboard.estimatedCostEur,
      previousMonthTotalKwh: Math.round(previousMonthTotalKwh * 100) / 100,
      monthEvolutionPercent: dashboard.previousMonthEvolutionPercent ?? 0,
      lastUpdated: new Date(),
    }
  },
}
