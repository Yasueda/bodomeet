json.array!(@calendar_events) do |event|
  json.id event.id
  json.title event.name
  json.start (event.date + event.start_time.seconds_since_midnight.seconds)
  json.end (event.date + event.end_time.seconds_since_midnight.seconds)
  json.url event_path(event.id)
end