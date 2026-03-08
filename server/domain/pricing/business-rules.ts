import type { HcSlot } from '~/domain/pricing/types'
import type { EurPerKwh, Kwh } from '~/domain/shared/types'

export const isOffPeak = (time: string, hcSlots: HcSlot[]) =>
  hcSlots.some(({ start, end }) => {
    if (start <= end) return time >= start && time < end
    return time >= start || time < end
  })

export const dailyCost = (totalKwh: Kwh, hpRate: EurPerKwh, hcRate: EurPerKwh, hcRatio: number) => {
  const hcKwh = (totalKwh as number) * hcRatio
  const hpKwh = (totalKwh as number) * (1 - hcRatio)
  return hcKwh * (hcRate as number) + hpKwh * (hpRate as number)
}

export const projectedMonthlyCost = (
  dailyCosts: number[],
  daysInMonth: number,
  subscriptionEur: number,
) => {
  if (dailyCosts.length === 0) return subscriptionEur
  const averageDailyCost = dailyCosts.reduce((sum, cost) => sum + cost, 0) / dailyCosts.length
  return averageDailyCost * daysInMonth + subscriptionEur
}
