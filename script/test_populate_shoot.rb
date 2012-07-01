10000.times do |i|
  puts "Populating: #{i}"

  s = Shoot.new
  s.event = "Test #{i}"
  s.description = "Description #{i}"
  s.photographer = "Swami ABC"
  s.shot_on = Date.current
  s.reported_on = Date.current
  s.save!
end
