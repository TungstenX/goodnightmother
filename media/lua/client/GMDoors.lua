-- TODO LIST
-- Creaking sound when door open or close
-- forced wake up?

GMDoors = GMDoors or {}
GMDoors.debug = false
GMDoors.name = "Doors"
GMDoors.needScan = false
GMDoors.needOnSeeNewRoom = false
GMDoors.needUpdate = false
GMDoors.needSleepSpawn = true
GMDoors.spawnWeight = 10
GMDoors.meanness = 5
GMDoors.initMeanness = 5

GMDoors.DOOR_ACTION_IF_CLOSED = { 
  {10, "LOCK"}, -- 10% chance of locking a closed door
  {5, "DESTROY"}, -- 5% chance of destroying a closed door
  {90,"NOTHING"}
}
GMDoors.DOOR_LOCK_WITH_KEY = { 
  {10, "NO"}, -- 10% chance of locking a closed door
  {90,"YES"}
}
GMDoors.WINDOW_ACTION_IF_CLOSED = { 
  {10, "LOCK"}, -- 10% chance of locking a closed wondow
  {4, "PERMA_LOCK"}, -- 4% chance of permanent locking a closed wondow
  {2, "SMASH"}, -- 2% chance of smashing a closed wondow
  {84,"NOTHING"}
}

-- Do nothing
GMDoors.init = function()
end

GMDoors.getSound = function()
  return nil
end

function GMDoors.rummageForFirstKeyId(itemContainer)
  if itemContainer then
    local items = itemContainer:getItems()
    local size = items:size() 
    for i = size - 1, 0, -1 do
      local item = items:get(i)
      if GMDoors.debug then print('GM Doors: Checking item (' .. i .. ') name:             ', item:getName() or 'nil') end
      if GMDoors.debug then print('GM Doors: Checking item (' .. i .. ') display name:     ', item:getDisplayName() or 'nil') end
      if GMDoors.debug then print('GM Doors: Checking item (' .. i .. ') category:         ', item:getCategory() or 'nil') end
      local keyId = item:getKeyId()
      if keyId > -1 then
        return keyId
      end
      if item:getCategory() == "Container" then
        keyId = GMDoors.rummageForFirstKeyId(item:getInventory())
        if keyId > -1 then
          return keyId
        end
      end
    end
  end
  return -1 -- not found
end

function GMDoors.toggleWindowsAndDoors(square, north, player)
  local object = square:getDoorOrWindow(north)
  if object and instanceof(object, 'IsoDoor') then
    if not object:IsOpen() and object:isLocked() then
      --unlock before opening, because poltergeists are meanies
      object:setLockedByKey(false) -- setLockedByKey sets both is locked and is locked by key
      if GMDoors.debug then print("GM Doors: Door is closed and locked and now is unlocked") end
    end
    
    object:setCurtainOpen(not object:isCurtainOpen()) -- toggel curtains if it has any (both methods checks for curtains, only for doors)
    object:ToggleDoor(player) -- open if closed, closed if open - barricaded will make a sound and not toggle door state
    
    if object:IsOpen() then
      if GMDoors.debug then print("GM Doors: Door was closed and now is open") end
    else -- could not have been opend and barricade 
      if GMDoors.debug then print("GM Doors: Door was open and now is closed") end
      -- do something mean
      local meanAction = GMUtils.weightedRandom(GMDoors.DOOR_ACTION_IF_CLOSED)
      if meanAction == "LOCK" then
        local withKey = GMUtils.weightedRandom(GMDoors.DOOR_LOCK_WITH_KEY)
        local strWithKey = ""
        if withKey == "YES" then          
          local keyId = object:checkKeyId()
          if keyId == -1 then
            --get players first key 
            keyId = GMDoors.rummageForFirstKeyId(player:getInventory())
          end
          if keyId > -1 then -- if no key could be found then skip this to just lock it
            object:setKeyId(keyId) -- some syncing happening in the java code
            object:setLockedByKey(true)
            strWithKey = " with a key"
          end          
        end
        object:setLocked(true)
        if GMDoors.debug then print("GM Doors: Locking door" .. strWithKey) end
      elseif meanAction == "DESTROY" then
        object:destroy()
        if GMDoors.debug then print("GM Doors: Destroying door") end
      end
      --else do nothing
    end
  elseif object and instanceof(object, 'IsoWindow') then
    if not object:isDestroyed() then
      if not object:IsOpen() and (object:isLocked() or object:isPermaLocked()) then
        --unlock before opening, because poltergeists are meanies
        object:setIsLocked(false) -- unlock window
        object:setPermaLocked(false) -- unlock perma locked window, because poltergeists
        if GMDoors.debug then print("GM Doors: Window is closed and locked and now is unlocked") end
      end      
      object:ToggleWindow(player) -- open if closed, closed if open - barricaded will make a sound and not toggle door state
      if object:IsOpen() then
        if GMDoors.debug then print("GM Doors: Window was closed and now is open") end
      else -- could not have been opend and barricade 
        if GMDoors.debug then print("GM Doors: Window was open and now is closed") end
        -- do something mean
        local meanAction = GMUtils.weightedRandom(GMDoors.WINDOW_ACTION_IF_CLOSED)
        if meanAction == "LOCK" then
          object:setIsLocked(true)
          if GMDoors.debug then print("GM Doors: Locking window") end
        elseif meanAction == "PERMA_LOCK" then
          object:setPermaLocked(true)
          if GMDoors.debug then print("GM Doors: Perma locking window") end
        elseif meanAction == "SMASH" then
          object:smashWindow()
          if GMDoors.debug then print("GM Doors: Smashing window") end
        end
      --else do nothing
      end
    end
    --Do the curtains      
    local isoCurtain = object:HasCurtains()
    if isoCurtain then
      isoCurtain:ToggleDoor(player) -- toggel curtains (door?) if it has any
    end 
  end
end

--Spawn windows and doors nightmare
-- IsoRoom getWindows doesn't work
GMDoors.spawn = function(player)
  if player:isInARoom() then
    if GMDoors.debug then print("GM Doors: Player is in a room") end  
    local buildingDef = player:getCurrentBuildingDef()
    if buildingDef then
      if GMDoors.debug then print("GM Doors: buildingDef") end
      local roomDefs = buildingDef:getRooms()
      if roomDefs then
        local size = roomDefs:size()
        if GMDoors.debug then print("GM Doors: The number of roomDefs in building ", size) end
        for i = 0, size - 1, 1 do
          local roomDef = roomDefs:get(i)
          if roomDef then
            if GMDoors.debug then print("GM Doors: roomDef [" .. i .. "] ", roomDef:getName()) end
            local isoRoom = roomDef:getIsoRoom()
            if isoRoom then
              if GMDoors.debug then print("GM Doors: room [" .. i .. "] ", isoRoom:getName()) end
              local squares = isoRoom:getSquares()
              local sqSize = squares:size()
              if GMDoors.debug then print("GM Doors: squares in room [" .. i .. "] ", sqSize) end
              for j = 0, sqSize - 1 do
                local square = squares:get(j)
                GMDoors.toggleWindowsAndDoors(square, true, player)
                GMDoors.toggleWindowsAndDoors(square, false, player)
              end        
            else
              if GMDoors.debug then print("GM Doors: isoRoom is nil") end
            end
          else
            if GMDoors.debug then print("GM Doors: roomDef is nil") end
          end    
        end
      else
        if GMDoors.debug then print("GM Doors: roomDefs is nil") end
      end  
    else
      if GMDoors.debug then print("GM Doors: buildingDef is nil") end
    end    
  elseif player:isSeatedInVehicle() then
    if GMDoors.debug then print("GM Doors: Player is in a vehicle") end 
    local baseVehicle = player:getVehicle()
    if baseVehicle then
      local numberOfParts = baseVehicle:getPartCount()
      for i = 0, numberOfParts - 1, 1 do
        local part = baseVehicle:getPartByIndex(i)
        if part then          
          local door = part:getDoor()
          if door then
            if GMDoors.debug then print("GM Doors: Found a door, toggle lock state") end 
            door:setLocked(not door:isLocked())
          end
          local window = part:findWindow()
          if window then
            if GMDoors.debug then print("GM Doors: Found a window") end 
            if not window:isDestroyed() and window:isOpenable()then
              if GMDoors.debug then print("GM Doors: Toggle window state") end 
              window:setOpen(not window:isOpen())
            end
          end
        end        
      end
    end
  else
    if GMDoors.debug then print("GM Doors: Player is not in a room or vehicle") end 
  end
  --change stats
  GMSanity.updateStats(player, GMDoors.meanness, 10)
end

function GMDoors.daily(insanityFactor)
  local factor = 0.5/5
  GMDoors.meanness = GMUtils.changeMeanness(insanityFactor, GMDoors.initMeanness, GMDoors.meanness, factor)
end