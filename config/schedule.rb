every 1.day do
  rake 'st:overview'
  rake 'st:retention'
  rake 'st:hit'
  rake 'st:online'
  rake 'mob:access_token'
end
every 1.hour do
  rake 'rank:week'
  rake 'rank:month'
end

