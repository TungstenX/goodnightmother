GMUtils = {}
GMUtils.debug = false

-- Picked a weighted random entry from the supplied pool
-- param pool e.g.
-- pool = {
--   {20, "foo"},
--   {20, "bar"},
--   {60, "baz"}
-- }
function GMUtils.weightedRandom(pool)
  local poolsize = 0
  for k,v in pairs(pool) do
    poolsize = poolsize + v[1]
  end
  local selection = ZombRand(poolsize) + 1
  if GMUtils.debug then print("GM poolsize = " .. tostring(poolsize) .. " poolsize = " .. tostring(selection)) end
  for k,v in pairs(pool) do
    selection = selection - v[1] 
    if (selection <= 0) then
      if GMUtils.debug then print("GM return = " .. tostring(v[2])) end
      return v[2]
    end
  end
end