import { PricingConfigId, PricingConfigInput } from '~/domain/pricing/primitives'
import { pricingConfigRepository } from '~/domain/pricing/repository'
import type { PricingConfig } from '~/domain/pricing/types'
import { Eur, EurPerKwh } from '~/domain/shared/primitives'

export const PricingCommand = {
  configure: async (input: unknown) => {
    const parsed = PricingConfigInput.parse(input)
    const config: PricingConfig = {
      id: PricingConfigId('current'),
      tariffType: 'hc-hp',
      hpRate: EurPerKwh(parsed.hpRate),
      hcRate: EurPerKwh(parsed.hcRate),
      hcSlots: parsed.hcSlots,
      subscriptionMonthlyEur: Eur(parsed.subscriptionMonthlyEur),
      updatedAt: new Date(),
    }
    await pricingConfigRepository.save(config)
    return { outcome: 'configured' } as const
  },
}
