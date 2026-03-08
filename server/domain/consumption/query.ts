import {
  dailyConsumptionRepository,
  loadCurveRepository,
  maxPowerRepository,
} from '~/domain/consumption/repository'

export const ConsumptionQuery = {
  dailyByRange: async (start: Date, end: Date) => {
    return await dailyConsumptionRepository.findByDateRange(start, end)
  },

  loadCurveByDate: async (date: Date) => {
    return await loadCurveRepository.findByDate(date)
  },

  loadCurveByRange: async (start: Date, end: Date) => {
    return await loadCurveRepository.findByDateRange(start, end)
  },

  maxPowerByRange: async (start: Date, end: Date) => {
    return await maxPowerRepository.findByDateRange(start, end)
  },
}
