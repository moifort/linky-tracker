import { ConsumptionQuery } from '~/domain/consumption/query'
import { isOffPeak } from '~/domain/pricing/business-rules'
import { PricingQuery } from '~/domain/pricing/query'

export const HcHpDistributionReadModel = {
  forDateRange: async (start: Date, end: Date) => {
    const config = await PricingQuery.currentConfig()
    const loadCurves = await ConsumptionQuery.loadCurveByRange(start, end)

    if (!config || loadCurves.length === 0) {
      return {
        totalHcKwh: 0,
        totalHpKwh: 0,
        hcPercent: 0,
        hpPercent: 0,
        hcCostEur: 0,
        hpCostEur: 0,
      }
    }

    let totalHcWh = 0
    let totalHpWh = 0

    for (const curve of loadCurves) {
      for (const reading of curve.readings) {
        const wh = reading.averageW / 2
        if (isOffPeak(reading.slot as string, config.hcSlots)) {
          totalHcWh += wh
        } else {
          totalHpWh += wh
        }
      }
    }

    const totalHcKwh = totalHcWh / 1000
    const totalHpKwh = totalHpWh / 1000
    const totalKwh = totalHcKwh + totalHpKwh
    const hcPercent = totalKwh > 0 ? (totalHcKwh / totalKwh) * 100 : 0
    const hpPercent = totalKwh > 0 ? (totalHpKwh / totalKwh) * 100 : 0

    return {
      totalHcKwh: Math.round(totalHcKwh * 100) / 100,
      totalHpKwh: Math.round(totalHpKwh * 100) / 100,
      hcPercent: Math.round(hcPercent * 10) / 10,
      hpPercent: Math.round(hpPercent * 10) / 10,
      hcCostEur: Math.round(totalHcKwh * (config.hcRate as number) * 100) / 100,
      hpCostEur: Math.round(totalHpKwh * (config.hpRate as number) * 100) / 100,
    }
  },
}
