import { PricingCommand } from '~/domain/pricing/command'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  const result = await PricingCommand.configure(body)
  return { status: 200, data: result }
})
