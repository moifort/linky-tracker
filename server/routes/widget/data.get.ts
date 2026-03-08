import { WidgetDataReadModel } from '~/read-model/widget/widget-data'

export default defineEventHandler(async () => {
  const data = await WidgetDataReadModel.data()
  return { status: 200, data }
})
