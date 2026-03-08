import { generateDomainInstrumentation } from './server/system/sentry/generate-domain-instrumentation'

export default defineNitroConfig({
  compatibilityDate: '2026-02-06',
  experimental: { asyncContext: true, tasks: true },
  srcDir: 'server',
  ignore: ['test/**', 'routes/test/**', '**/*.test.ts'],
  virtual: {
    '#domain-instrumentation': generateDomainInstrumentation,
  },
  runtimeConfig: {
    apiToken: '',
    sentryDsn: '',
    consoApiToken: '',
    consoApiPrm: '',
  },
  storage: {
    'migration-meta': { driver: 'fs', base: './.data/db/migration-meta' },
    'daily-consumption': { driver: 'fs', base: './.data/db/daily-consumption' },
    'load-curve': { driver: 'fs', base: './.data/db/load-curve' },
    'max-power': { driver: 'fs', base: './.data/db/max-power' },
    'pricing-config': { driver: 'fs', base: './.data/db/pricing-config' },
    'sync-meta': { driver: 'fs', base: './.data/db/sync-meta' },
  },
  scheduledTasks: {
    '0 10 * * *': ['sync:daily', 'sync:max-power'],
    '0 11 * * *': ['sync:load-curve'],
  },
})
