import { PricingQuery } from '~/domain/pricing/query'

export default defineEventHandler(async () => {
  const data = await PricingQuery.currentConfig()
  return { status: 200, data }
})
