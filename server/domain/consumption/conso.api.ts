import { z } from 'zod'
import { createLogger } from '~/system/logger'

const logger = createLogger('conso-api')

const BASE_URL = 'https://conso.boris.sh/api'

const intervalReadingSchema = z.object({
  interval_reading: z.array(
    z.object({
      value: z.string(),
      date: z.string(),
    }),
  ),
})

const formatDate = (date: Date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`

const fetchFromConsoApi = async (
  token: string,
  prm: string,
  endpoint: string,
  start: Date,
  end: Date,
) => {
  const url = `${BASE_URL}/${endpoint}?prm=${prm}&start=${formatDate(start)}&end=${formatDate(end)}`
  logger.info(`Fetching ${endpoint} from ${formatDate(start)} to ${formatDate(end)}`)

  const response = await fetch(url, {
    headers: { Authorization: `Bearer ${token}` },
  })

  if (!response.ok) {
    throw new Error(`Conso API error: ${response.status} ${response.statusText}`)
  }

  const data = await response.json()
  return intervalReadingSchema.parse(data)
}

export const ConsoApi = {
  fetchDailyConsumption: async (token: string, prm: string, start: Date, end: Date) => {
    const result = await fetchFromConsoApi(token, prm, 'daily_consumption', start, end)
    return result.interval_reading
  },

  fetchLoadCurve: async (token: string, prm: string, start: Date, end: Date) => {
    const result = await fetchFromConsoApi(token, prm, 'consumption_load_curve', start, end)
    return result.interval_reading
  },

  fetchMaxPower: async (token: string, prm: string, start: Date, end: Date) => {
    const result = await fetchFromConsoApi(token, prm, 'daily_consumption_max_power', start, end)
    return result.interval_reading
  },
}
