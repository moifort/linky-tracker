import { make } from 'ts-brand'
import { z } from 'zod'
import type {
  DailyConsumptionId as DailyConsumptionIdType,
  HalfHourSlot as HalfHourSlotType,
} from '~/domain/consumption/types'

export const DailyConsumptionId = (value: unknown) => {
  const v = z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/)
    .parse(value)
  return make<DailyConsumptionIdType>()(v)
}

export const HalfHourSlot = (value: unknown) => {
  const v = z
    .string()
    .regex(/^\d{2}:\d{2}$/)
    .parse(value)
  return make<HalfHourSlotType>()(v)
}
