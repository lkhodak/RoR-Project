json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :date, :start, :end, :references
  json.url schedule_url(schedule, format: :json)
end
