import { DailyConsumptionId, HalfHourSlot } from '~/domain/consumption/primitives'
import {
  dailyConsumptionRepository,
  loadCurveRepository,
  maxPowerRepository,
} from '~/domain/consumption/repository'
import type {
  DailyConsumption,
  DailyLoadCurve,
  DailyMaxPower,
  LoadCurveReading,
} from '~/domain/consumption/types'
import { Kva, Wh } from '~/domain/shared/primitives'

type ApiIntervalReading = { value: string; date: string }

export const ConsumptionCommand = {
  syncDaily: async (readings: ApiIntervalReading[]) => {
    const now = new Date()
    const consumptions: DailyConsumption[] = readings.map((reading) => {
      const date = new Date(reading.date)
      return {
        id: DailyConsumptionId(formatDateKey(date)),
        date,
        totalWh: Wh(reading.value),
        fetchedAt: now,
      }
    })
    await dailyConsumptionRepository.saveMany(consumptions)
    return { outcome: 'synced', count: consumptions.length } as const
  },

  syncLoadCurve: async (readings: ApiIntervalReading[]) => {
    const now = new Date()
    const byDay = new Map<string, LoadCurveReading[]>()

    for (const reading of readings) {
      const date = new Date(reading.date)
      const dayKey = formatDateKey(date)
      const slot = `${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`

      if (!byDay.has(dayKey)) byDay.set(dayKey, [])
      byDay.get(dayKey)!.push({
        slot: HalfHourSlot(slot),
        averageW: Number(reading.value),
      })
    }

    const loadCurves: DailyLoadCurve[] = [...byDay.entries()].map(([dayKey, dayReadings]) => ({
      id: DailyConsumptionId(dayKey),
      date: new Date(dayKey),
      readings: dayReadings,
      fetchedAt: now,
    }))

    await loadCurveRepository.saveMany(loadCurves)
    return { outcome: 'synced', count: loadCurves.length } as const
  },

  syncMaxPower: async (readings: ApiIntervalReading[]) => {
    const now = new Date()
    const maxPowers: DailyMaxPower[] = readings.map((reading) => {
      const timestamp = new Date(reading.date)
      const date = new Date(formatDateKey(timestamp))
      return {
        id: DailyConsumptionId(formatDateKey(date)),
        date,
        maxKva: Kva(Number(reading.value) / 1000),
        maxTimestamp: timestamp,
        fetchedAt: now,
      }
    })
    await maxPowerRepository.saveMany(maxPowers)
    return { outcome: 'synced', count: maxPowers.length } as const
  },
}

const formatDateKey = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
