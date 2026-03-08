import type { Brand } from 'ts-brand'
import type { Kva, Wh } from '~/domain/shared/types'

export type DailyConsumptionId = Brand<string, 'DailyConsumptionId'>
export type HalfHourSlot = Brand<string, 'HalfHourSlot'>

export type DailyConsumption = {
  id: DailyConsumptionId
  date: Date
  totalWh: Wh
  fetchedAt: Date
}

export type LoadCurveReading = {
  slot: HalfHourSlot
  averageW: number
}

export type DailyLoadCurve = {
  id: DailyConsumptionId
  date: Date
  readings: LoadCurveReading[]
  fetchedAt: Date
}

export type DailyMaxPower = {
  id: DailyConsumptionId
  date: Date
  maxKva: Kva
  maxTimestamp: Date
  fetchedAt: Date
}
