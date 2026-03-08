import { describe, expect, test } from 'bun:test'
import { Country, Eur, EurPerKwh, Kva, Kwh, Wh, Year } from '~/domain/shared/primitives'

describe('Eur', () => {
  test('accepts a positive number', () => {
    expect(Eur(9.99)).toBe(Eur(9.99))
  })

  test('accepts zero', () => {
    expect(Eur(0)).toBe(Eur(0))
  })

  test('coerces a string to number', () => {
    expect(Eur('12.5')).toBe(Eur(12.5))
  })

  test('rejects a negative number', () => {
    expect(() => Eur(-1)).toThrow()
  })
})

describe('Year', () => {
  test('accepts a valid year', () => {
    expect(Year(2020)).toBe(Year(2020))
  })

  test('coerces a string to number', () => {
    expect(Year('2020')).toBe(Year(2020))
  })

  test('rejects a year before 1800', () => {
    expect(() => Year(1799)).toThrow()
  })

  test('rejects a non-integer', () => {
    expect(() => Year(2020.5)).toThrow()
  })
})

describe('Country', () => {
  test('accepts a non-empty string', () => {
    expect(Country('France')).toBe(Country('France'))
  })

  test('rejects an empty string', () => {
    expect(() => Country('')).toThrow()
  })
})

describe('Wh', () => {
  test('accepts a positive number', () => {
    expect(Wh(1500)).toBe(Wh(1500))
  })

  test('coerces a string to number', () => {
    expect(Wh('1500')).toBe(Wh(1500))
  })

  test('rejects a negative number', () => {
    expect(() => Wh(-1)).toThrow()
  })
})

describe('Kva', () => {
  test('accepts a positive number', () => {
    expect(Kva(6)).toBe(Kva(6))
  })

  test('rejects a negative number', () => {
    expect(() => Kva(-1)).toThrow()
  })
})

describe('Kwh', () => {
  test('accepts a positive number', () => {
    expect(Kwh(12.5)).toBe(Kwh(12.5))
  })

  test('coerces a string to number', () => {
    expect(Kwh('12.5')).toBe(Kwh(12.5))
  })

  test('rejects a negative number', () => {
    expect(() => Kwh(-1)).toThrow()
  })
})

describe('EurPerKwh', () => {
  test('accepts a positive number', () => {
    expect(EurPerKwh(0.174)).toBe(EurPerKwh(0.174))
  })

  test('rejects a negative number', () => {
    expect(() => EurPerKwh(-0.01)).toThrow()
  })
})
