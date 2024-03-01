require "ISMoveableDefinitions"

GMSleepWalker = {}
GMSleepWalker.debug = false

-- Get random room def
function GMSleepWalker.getRandomRoomDef(building, notId, triesRef)
  if building ~= nil then
    if GMSleepWalker.debug then print("GM SleepWlaker: Building id: ", building:getID() or 'nil') end        
    -- get random room, that is not this room
    local randomRoom = building:getRandomRoom()
    if randomRoom ~= nil then
      local randomRoomDef = randomRoom:getRoomDef()
      if randomRoomDef ~= nil then
        if randomRoomDef:getID() ~= notId then
          return randomRoom
        elseif((tries[1] > 0) and (randomRoomDef:getID() == notId)) then
          tries[1] = tries[1] - 1
          return GMSleepWalker.getRandomRoomDef(building, notId, tries)
        else -- should be tries == 0 and randomRoomDef:getID() == roomDef:getID()
          if GMSleepWalker.debug then print("GM SleepWlaker: One room house?") end
          return nil
        end
      end
    end
  end
  return nil
end

-- Move player to other room in the same building
-- Keeping with the naming convention
function GMSleepWalker.spawn()
  local otherRoomDef = nil
  local player = getPlayer()
  if player:isInARoom() then
    local roomDef = player:getCurrentRoomDef()
    -- Finding room
    if roomDef ~= nil then
      if GMSleepWalker.debug then print("GM SleepWlaker: Current roomDef name: " .. roomDef:getName() .. " id: " .. roomDef:getID()) end
      local room = roomDef:getIsoRoom()
      if room ~= nil then
        if GMSleepWalker.debug then print("GM SleepWlaker: Room name: ", room:getName() or 'nil') end
        local tries = 5
        local triesRef = {tries}
        otherRoomDef = getRandomRoomDef(room:getBuilding(), roomDef:getID(), triesRef)
      end
    end
    
    -- Lets see if we can SleepWalk (teleport) player to another room
    if otherRoomDef ~= nil then
      if GMSleepWalker.debug then print("GM SleepWlaker: Trying to sleep walk to new room id ", otherRoomDef:getID() or 'nil') end
      local freeSquare = otherRoomDef:getFreeSquare()
      if freeSquare ~= nil then
        -- start foot steps
        ISMoveableDefinitions.playSound(player, "Walk", true)
        player:setX(freeSquare:getX())
        player:setY(freeSquare:getY())
        player:setZ(freeSquare:getZ())
        -- end foot steps
        ISMoveableDefinitions.playSound(player, "Walk", true)        
        if GMSleepWalker.debug then print("GM SleepWlaker: Sleep walked to new room (" .. freeSquare:getX() .. ", " .. freeSquare:getY() .. ", " .. freeSquare:getZ() .. ")") end
      end        
    end
  end
end
