import { make } from 'ts-brand'
import { z } from 'zod'
import type { PricingConfigId as PricingConfigIdType } from '~/domain/pricing/types'

export const PricingConfigId = (value: unknown) => {
  const v = z.string().min(1).parse(value)
  return make<PricingConfigIdType>()(v)
}

export const HcSlotSchema = z.object({
  start: z.string().regex(/^\d{2}:\d{2}$/),
  end: z.string().regex(/^\d{2}:\d{2}$/),
})

export const PricingConfigInput = z.object({
  hpRate: z.number().nonnegative(),
  hcRate: z.number().nonnegative(),
  hcSlots: z.array(HcSlotSchema).min(1),
  subscriptionMonthlyEur: z.number().nonnegative(),
})
