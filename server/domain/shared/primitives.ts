import { make } from 'ts-brand'
import { z } from 'zod'
import type {
  Country as CountryType,
  Count as CountType,
  EurPerKwh as EurPerKwhType,
  Eur as EurType,
  Kva as KvaType,
  Kwh as KwhType,
  Wh as WhType,
  Year as YearType,
} from '~/domain/shared/types'

export const Eur = (value: unknown) => {
  const v = z
    .preprocess((v) => (typeof v === 'string' ? Number(v) : v), z.number().nonnegative())
    .parse(value)
  return make<EurType>()(v)
}

export const Year = (value: unknown) => {
  const v = z
    .preprocess((v) => (typeof v === 'string' ? Number(v) : v), z.number().int().min(1800))
    .parse(value)
  return make<YearType>()(v)
}

export const Country = (value: unknown) => {
  const v = z.string().min(1).parse(value)
  return make<CountryType>()(v)
}

export const Count = (value: number) => make<CountType>()(value)

export const Wh = (value: unknown) => {
  const v = z
    .preprocess((v) => (typeof v === 'string' ? Number(v) : v), z.number().nonnegative())
    .parse(value)
  return make<WhType>()(v)
}

export const Kva = (value: unknown) => {
  const v = z
    .preprocess((v) => (typeof v === 'string' ? Number(v) : v), z.number().nonnegative())
    .parse(value)
  return make<KvaType>()(v)
}

export const Kwh = (value: unknown) => {
  const v = z
    .preprocess((v) => (typeof v === 'string' ? Number(v) : v), z.number().nonnegative())
    .parse(value)
  return make<KwhType>()(v)
}

export const EurPerKwh = (value: unknown) => {
  const v = z
    .preprocess((v) => (typeof v === 'string' ? Number(v) : v), z.number().nonnegative())
    .parse(value)
  return make<EurPerKwhType>()(v)
}
