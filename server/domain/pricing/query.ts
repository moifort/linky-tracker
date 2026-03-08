import { pricingConfigRepository } from '~/domain/pricing/repository'

export const PricingQuery = {
  currentConfig: async () => {
    return await pricingConfigRepository.findCurrent()
  },
}
