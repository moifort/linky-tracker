import type { DailyConsumption, DailyLoadCurve, DailyMaxPower } from '~/domain/consumption/types'

const formatDate = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`

const dailyConsumptionStorage = () => useStorage<DailyConsumption>('daily-consumption')

export const dailyConsumptionRepository = {
  findByDate: async (date: Date) => {
    return await dailyConsumptionStorage().getItem(formatDate(date))
  },

  findByDateRange: async (start: Date, end: Date) => {
    const keys = await dailyConsumptionStorage().getKeys()
    const startStr = formatDate(start)
    const endStr = formatDate(end)
    const matchingKeys = keys.filter((key) => key >= startStr && key <= endStr)
    if (matchingKeys.length === 0) return []
    const items = await dailyConsumptionStorage().getItems(matchingKeys)
    return items.map(({ value }) => value).filter(Boolean) as DailyConsumption[]
  },

  save: async (consumption: DailyConsumption) => {
    await dailyConsumptionStorage().setItem(formatDate(consumption.date), consumption)
  },

  saveMany: async (consumptions: DailyConsumption[]) => {
    for (const consumption of consumptions) {
      await dailyConsumptionStorage().setItem(formatDate(consumption.date), consumption)
    }
  },
}

const loadCurveStorage = () => useStorage<DailyLoadCurve>('load-curve')

export const loadCurveRepository = {
  findByDate: async (date: Date) => {
    return await loadCurveStorage().getItem(formatDate(date))
  },

  findByDateRange: async (start: Date, end: Date) => {
    const keys = await loadCurveStorage().getKeys()
    const startStr = formatDate(start)
    const endStr = formatDate(end)
    const matchingKeys = keys.filter((key) => key >= startStr && key <= endStr)
    if (matchingKeys.length === 0) return []
    const items = await loadCurveStorage().getItems(matchingKeys)
    return items.map(({ value }) => value).filter(Boolean) as DailyLoadCurve[]
  },

  save: async (loadCurve: DailyLoadCurve) => {
    await loadCurveStorage().setItem(formatDate(loadCurve.date), loadCurve)
  },

  saveMany: async (loadCurves: DailyLoadCurve[]) => {
    for (const loadCurve of loadCurves) {
      await loadCurveStorage().setItem(formatDate(loadCurve.date), loadCurve)
    }
  },
}

const maxPowerStorage = () => useStorage<DailyMaxPower>('max-power')

export const maxPowerRepository = {
  findByDate: async (date: Date) => {
    return await maxPowerStorage().getItem(formatDate(date))
  },

  findByDateRange: async (start: Date, end: Date) => {
    const keys = await maxPowerStorage().getKeys()
    const startStr = formatDate(start)
    const endStr = formatDate(end)
    const matchingKeys = keys.filter((key) => key >= startStr && key <= endStr)
    if (matchingKeys.length === 0) return []
    const items = await maxPowerStorage().getItems(matchingKeys)
    return items.map(({ value }) => value).filter(Boolean) as DailyMaxPower[]
  },

  save: async (maxPower: DailyMaxPower) => {
    await maxPowerStorage().setItem(formatDate(maxPower.date), maxPower)
  },

  saveMany: async (maxPowers: DailyMaxPower[]) => {
    for (const maxPower of maxPowers) {
      await maxPowerStorage().setItem(formatDate(maxPower.date), maxPower)
    }
  },
}
