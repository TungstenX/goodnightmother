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
-- Do walking sounds?
-- In vehicle and in tent?

GMSleepWalker = GMSleepWalker or {}
GMSleepWalker.debug = false
GMSleepWalker.name = "Sleep Walker"
GMSleepWalker.needScan = false
GMSleepWalker.needOnSeeNewRoom = false
GMSleepWalker.needUpdate = false
GMSleepWalker.needSleepSpawn = true
GMSleepWalker.spawnWeight = 10
GMSleepWalker.meanness = 4
GMSleepWalker.initMeanness = 4

-- Get random room def
function GMSleepWalker.getRandomRoomDef(building, notId, triesRef)
  if GMSleepWalker.debug then print("GM SleepWalker: notId " .. notId .. " tries: " .. triesRef[1]) end
  if building ~= nil then
    if GMSleepWalker.debug then print("GM SleepWalker: Building id: ", building:getID() or 'nil') end        
    -- get random room, that is not this room
    local randomRoom = building:getRandomRoom()
    if randomRoom ~= nil then
      if GMSleepWalker.debug then print("GM SleepWalker: randomRoom name: ", randomRoom:getName() or 'nil') end
      local randomRoomDef = randomRoom:getRoomDef()
      if randomRoomDef ~= nil then
        if GMSleepWalker.debug then print("GM SleepWalker: randomRoomDef id: ", randomRoomDef:getID() or 'nil') end
        if randomRoomDef:getID() ~= notId then
          if GMSleepWalker.debug then print("GM SleepWalker: Got room") end
          return randomRoomDef
        elseif((triesRef[1] > 0) and (randomRoomDef:getID() == notId)) then
          triesRef[1] = triesRef[1] - 1
          return GMSleepWalker.getRandomRoomDef(building, notId, triesRef)
        else -- should be tries == 0 and randomRoomDef:getID() == roomDef:getID()
          if GMSleepWalker.debug then print("GM SleepWalker: One room house?") end
          return nil
        end
      end
    end
  end
  return nil
end

-- Move player to other room in the same building
GMSleepWalker.spawn = function(player)
  local otherRoomDef = nil
  if player:isInARoom() then
    local roomDef = player:getCurrentRoomDef()
    -- Finding room
    if roomDef ~= nil then
      if GMSleepWalker.debug then print("GM SleepWalker: Current roomDef name: " .. roomDef:getName() .. " id: " .. roomDef:getID()) end
      local room = roomDef:getIsoRoom()
      if room ~= nil then
        if GMSleepWalker.debug then print("GM SleepWalker: Room name: ", room:getName() or 'nil') end
        local tries = 5
        local triesRef = {tries}
        otherRoomDef = GMSleepWalker.getRandomRoomDef(room:getBuilding(), roomDef:getID(), triesRef)
      end
    end
    
    -- Lets see if we can SleepWalk (teleport) player to another room
    if otherRoomDef ~= nil then
      if GMSleepWalker.debug then print("GM SleepWalker: Trying to sleep walk to new room id ", otherRoomDef:getID() or 'nil') end
      local isoRoom = otherRoomDef:getIsoRoom()      
      local freeSquare = isoRoom:getRandomFreeSquare()
      if freeSquare == nil then
        freeSquare = isoRoom:getRandomSquare()
      end      
      if freeSquare ~= nil then
        player:setX(freeSquare:getX())
        player:setY(freeSquare:getY())
        player:setZ(freeSquare:getZ())     
        if GMSleepWalker.debug then print("GM SleepWalker: Sleep walked to new room (" .. freeSquare:getX() .. ", " .. freeSquare:getY() .. ", " .. freeSquare:getZ() .. ")") end
      end        
    end
  end
end

function GMSleepWalker.daily(insanityFactor)
  local factor = 0.5/5
  GMSleepWalker.meanness = GMUtils.changeMeanness(insanityFactor, GMSleepWalker.initMeanness, GMSleepWalker.meanness, factor)
end
