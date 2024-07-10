declare interface Tournament {
  id: number
  created_at: string
  name: string
  description: string
  slug: string
  start_date?: string|null
  end_date?: string|null
}
