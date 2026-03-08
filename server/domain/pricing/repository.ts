import type { PricingConfig } from '~/domain/pricing/types'

const pricingStorage = () => useStorage<PricingConfig>('pricing-config')

export const pricingConfigRepository = {
  findCurrent: async () => {
    return await pricingStorage().getItem('current')
  },

  save: async (config: PricingConfig) => {
    await pricingStorage().setItem('current', config)
  },
}
