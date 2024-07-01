-- ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐                                                                                                     
-- │ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
-- │    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
-- │   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
-- │  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
-- │ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ © Copyright 2024                                                                                   │ 
-- └────────────────────────────────────────────────────────────────────────────────────────────────────┘


-- TODO LIST
-- 

GMNightNoises = GMNightNoises or {}
GMNightNoises.debug = false
GMNightNoises.name = "Night Noises"
GMNightNoises.needScan = false
GMNightNoises.needOnSeeNewRoom = false
GMNightNoises.needUpdate = false
GMNightNoises.needSleepSpawn = true
GMNightNoises.spawnWeight = 10
GMNightNoises.meanness = 0
GMNightNoises.initMeanness = 0
GMNightNoises.sound = nil
GMNightNoises.maxHoursToSleep = 12
GMNightNoises.minutesSleeping = 0
GMNightNoises.SOUNDS = {
  {10,"BLAH"}
}
GMNightNoises.SOUNDS_HOUSE = {
  {100, nil},
  {10, "GMNightRoom0"},
  {30, "GMNightRoom1"},
  {30, "GMNightRoom2"},
  {30, "GMNightRoom3"},
  {30, "GMNightRoom4"},
  {20, "GMNightRoom7"},
  {20, "GMNightRoom8"}
}
GMNightNoises.SOUNDS_OUTSIDE = {
  {100, nil},
  {30,"GMNightRoom4"},
  {20,"GMNightRoom5"},
  {20,"GMNightRoom6"},
  {20,"GMNightRoom8"},
  {20,"GMNightRoom9"}
}

GMNightNoises.getSound = function()
  GMUtils.debug = GMNightNoises.debug
  return GMUtils.weightedRandom(GMNightNoises.SOUNDS)  
end

GMNightNoises.EveryTenMinutes = function()
  GMUtils.debug = GMNightNoises.debug
  
  GMNightNoises.minutesSleeping = GMNightNoises.minutesSleeping + 10
  
  if GMNightNoises.sound then
    GMNightNoises.sound:stop()
    GMNightNoises.sound = nil
  end
  
  local player = getPlayer()
  
  local sound = nil
  local sq = payer:getCurrentSquare()
  if player:isInARoom() then
    sound = GMUtils.weightedRandom(GMNightNoises.SOUNDS_HOUSE) 
    if not sound then return end
    local roomDef = player:getCurrentRoomDef()
    if roomDef then
      local isoRoom = roomDef:getIsoRoom()
      if isoRoom then
        sq = isoRoom:getRandomSquare()
      end      
    end
  else
    --outside
    sound = GMUtils.weightedRandom(GMNightNoises.SOUNDS_OUTSIDE) 
    if not sound then return end
    local x, y, z = player:getX(), player:getY(), player:getZ()
    x = x + ZombRand(-5, 5)
    y = y + ZombRand(-5, 5)
    sq = getSquare(x, y, z)
  end
  
  GMNightNoises.sound = getSoundManager():PlayWorldSound(sound, false, player:getCurrentSquare(), 0.2, 60, 0.5, false)  
    
  --change stats
  GMSanity.updateStats(player, GMNightNoises.meanness, 1.0)
  
  --Force wake
  GMSanity.sanityResponse(player, GMNightNoises.minutesSleeping, GMNightNoises.minutesSleeping) 
end

GMNightNoises.spawn = function(player)  
  GMNightNoises.maxHoursToSleep = GMNightNoises.meanness + ((2 * (10 - GMNightNoises.meanness)) - 7)
  Events.EveryTenMinutes.Add(GMNightNoises.EveryTenMinutes)
end

GMNightNoises.unspawn = function(player)
  Events.EveryOneMinutes.Remove(GMNightNoises.EveryOneMinutes)  
  if GMNightNoises.sound then
    GMNightNoises.sound:stop()
    GMNightNoises.sound = nil
  end
end

function GMNightNoises.daily(insanityFactor)
  local factor = 1/5
  GMNightNoises.meanness = GMUtils.changeMeanness(insanityFactor, GMNightNoises.initMeanness, GMNightNoises.meanness, factor)
end