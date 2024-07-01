-- ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐                                                                                                     
-- │ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
-- │    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
-- │   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
-- │  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
-- │ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ © Copyright 2024                                                                                   │ 
-- └────────────────────────────────────────────────────────────────────────────────────────────────────┘

GMUtils = GMUtils or {}
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
  if GMUtils.debug then print("GM weightedRandom: poolsize = " .. tostring(poolsize) .. " poolsize = " .. tostring(selection)) end
  for k,v in pairs(pool) do
    selection = selection - v[1] 
    if (selection <= 0) then
      if GMUtils.debug then print("GM weightedRandom: return = " .. tostring(v[2])) end
      return v[2]
    end
  end
end

-- Recalulate the weight for the entries in the pool
-- entries must have a meanness property
function GMUtils.reweight(pool)
  for k,v in pairs(pool) do
    local old = v[1]
    local meanness = tonumber(v[2].meanness)
    if GMUtils.debug then print("GM Utils: reweight v[2] = ", meanness) end
    v[1] = math.ceil(100.0 / ((v[2].meanness + 1.0) * 1.4))
    if GMUtils.debug then print("GM Utils: reweight: weight from " .. tostring(old) .. " to " .. tostring(v[1])) end
  end
end

-- Get the direction the object must face to look at the player
-- return one of the IsoDirection enum
function GMUtils.getDirectionToPlayer(object, player)
  local playerVec = Vector2.new(player:getX(), player:getY())
  local objectVec = Vector2.new(object:getX(), object:getY())
  local angle = objectVec:angleTo(playerVec)
  if angle >= -0.3926990817 and angle < 0.3926990817 then -- [-22.5 to 22.5)
    return IsoDirections.E
  elseif angle >= 0.3926990817 and angle < 1.1780972451 then -- [22.5 to 67.5)
    return IsoDirections.SE
  elseif angle >= 1.1780972451 and angle < 1.9634954085 then -- [67.5 to 112.5)
    return IsoDirections.S
  elseif angle >= 1.9634954085 and angle < 2.7488935719 then -- [112.5 to 157.5)
    return IsoDirections.SW
  elseif angle >= -1.1780972451 and angle < -0.3926990817 then -- [-67.5 to -22.5)
    return IsoDirections.NE
  elseif angle >= -1.9634954085 and angle < -1.1780972451 then -- [-112.5 to -67.5)
    return IsoDirections.N
  elseif angle >= -2.7488935719 and angle < -1.9634954085 then -- [-157 to -112.5)
    return IsoDirections.NW
  else -- [22.5 to 67.5)
    return IsoDirections.W
  end
end

function GMUtils.getDirectionToPlayer2(object, playerVec)
  local objectVec = Vector2.new(object:getX(), object:getY())
  local angle = objectVec:angleTo(playerVec)
  if angle >= -0.3926990817 and angle < 0.3926990817 then -- [-22.5 to 22.5)
    return IsoDirections.E
  elseif angle >= 0.3926990817 and angle < 1.1780972451 then -- [22.5 to 67.5)
    return IsoDirections.SE
  elseif angle >= 1.1780972451 and angle < 1.9634954085 then -- [67.5 to 112.5)
    return IsoDirections.S
  elseif angle >= 1.9634954085 and angle < 2.7488935719 then -- [112.5 to 157.5)
    return IsoDirections.SW
  elseif angle >= -1.1780972451 and angle < -0.3926990817 then -- [-67.5 to -22.5)
    return IsoDirections.NE
  elseif angle >= -1.9634954085 and angle < -1.1780972451 then -- [-112.5 to -67.5)
    return IsoDirections.N
  elseif angle >= -2.7488935719 and angle < -1.9634954085 then -- [-157 to -112.5)
    return IsoDirections.NW
  else -- [22.5 to 67.5)
    return IsoDirections.W
  end
end

function GMUtils.changeMeanness(insanityFactor, initMeanness, meanness, factor)
  -- insanityFactor = 5 will take 10 days to go from 0 to 9 (initMeanness < 5) or 9 to 0 (initMeanness >= 5)
  if initMeanness < 5 then
    if meanness + (insanityFactor * factor)  <= 9.0 then
      meanness = meanness + (insanityFactor * factor)
    end
  else
    if meanness - (insanityFactor * factor) >= 0.0 then
      meanness = meanness - (insanityFactor * factor)
    end
  end
  return meanness
end

function GMUtils.startsWith(needle, haystack)
  if needle == nil or haystack == nil then
    return false
  end
 return string.sub(haystack, 1, string.len(needle)) == needle
end


--- Transform a square position into a unique string
---@param square IsoGridSquare
---@return string
function GMUtils.SquareToId(square)
    return square:getX() .. "|" .. square:getY() .. "|" .. square:getZ()
end

--- Transform a position into a unique string
---@param x number
---@param y number
---@param z number
---@return string
function GMUtils.PositionToId(x, y ,z)
    return x .. "|" .. y .. "|" .. z
end
