import { describe, expect, test } from 'bun:test'
import { DailyConsumptionId, HalfHourSlot } from '~/domain/consumption/primitives'

describe('DailyConsumptionId', () => {
  test('accepts a valid YYYY-MM-DD string', () => {
    expect(DailyConsumptionId('2024-01-15')).toBe(DailyConsumptionId('2024-01-15'))
  })

  test('rejects an invalid format', () => {
    expect(() => DailyConsumptionId('15/01/2024')).toThrow()
  })

  test('rejects a non-string', () => {
    expect(() => DailyConsumptionId(123)).toThrow()
  })
})

describe('HalfHourSlot', () => {
  test('accepts a valid HH:mm string', () => {
    expect(HalfHourSlot('14:30')).toBe(HalfHourSlot('14:30'))
  })

  test('rejects an invalid format', () => {
    expect(() => HalfHourSlot('2pm')).toThrow()
  })
})
