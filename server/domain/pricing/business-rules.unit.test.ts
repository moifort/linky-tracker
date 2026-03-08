import { describe, expect, test } from 'bun:test'
import { dailyCost, isOffPeak, projectedMonthlyCost } from '~/domain/pricing/business-rules'
import { EurPerKwh, Kwh } from '~/domain/shared/primitives'

describe('isOffPeak', () => {
  const hcSlots = [{ start: '22:00', end: '06:00' }]

  test('returns true during off-peak hours', () => {
    expect(isOffPeak('23:00', hcSlots)).toBe(true)
    expect(isOffPeak('02:30', hcSlots)).toBe(true)
  })

  test('returns false during peak hours', () => {
    expect(isOffPeak('10:00', hcSlots)).toBe(false)
    expect(isOffPeak('14:30', hcSlots)).toBe(false)
  })

  test('handles boundary at start', () => {
    expect(isOffPeak('22:00', hcSlots)).toBe(true)
  })

  test('handles boundary at end', () => {
    expect(isOffPeak('06:00', hcSlots)).toBe(false)
  })

  test('handles non-midnight-crossing slot', () => {
    const daySlots = [{ start: '12:00', end: '14:00' }]
    expect(isOffPeak('13:00', daySlots)).toBe(true)
    expect(isOffPeak('11:00', daySlots)).toBe(false)
    expect(isOffPeak('14:00', daySlots)).toBe(false)
  })

  test('handles multiple slots', () => {
    const multiSlots = [
      { start: '22:00', end: '06:00' },
      { start: '12:00', end: '14:00' },
    ]
    expect(isOffPeak('23:00', multiSlots)).toBe(true)
    expect(isOffPeak('13:00', multiSlots)).toBe(true)
    expect(isOffPeak('10:00', multiSlots)).toBe(false)
  })
})

describe('dailyCost', () => {
  test('calculates cost with mixed HC/HP', () => {
    const cost = dailyCost(Kwh(10), EurPerKwh(0.2), EurPerKwh(0.15), 0.4)
    // HC: 10 * 0.4 * 0.15 = 0.6
    // HP: 10 * 0.6 * 0.2 = 1.2
    expect(cost).toBeCloseTo(1.8)
  })

  test('calculates cost with 100% HP', () => {
    const cost = dailyCost(Kwh(10), EurPerKwh(0.2), EurPerKwh(0.15), 0)
    expect(cost).toBeCloseTo(2.0)
  })

  test('calculates cost with 100% HC', () => {
    const cost = dailyCost(Kwh(10), EurPerKwh(0.2), EurPerKwh(0.15), 1)
    expect(cost).toBeCloseTo(1.5)
  })
})

describe('projectedMonthlyCost', () => {
  test('projects based on average daily cost', () => {
    const projected = projectedMonthlyCost([2, 3, 4], 30, 10)
    // avg = 3, projected = 3 * 30 + 10 = 100
    expect(projected).toBeCloseTo(100)
  })

  test('returns subscription only when no data', () => {
    expect(projectedMonthlyCost([], 30, 10)).toBe(10)
  })
})
