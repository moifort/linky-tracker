import type { Brand } from 'ts-brand'
import type { Eur, EurPerKwh } from '~/domain/shared/types'

export type PricingConfigId = Brand<string, 'PricingConfigId'>

export type HcSlot = {
  start: string
  end: string
}

export type PricingConfig = {
  id: PricingConfigId
  tariffType: 'hc-hp'
  hpRate: EurPerKwh
  hcRate: EurPerKwh
  hcSlots: HcSlot[]
  subscriptionMonthlyEur: Eur
  updatedAt: Date
}
