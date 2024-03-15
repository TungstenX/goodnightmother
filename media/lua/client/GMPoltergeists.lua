-- The Poltergeists will either move furniture (only one square big) around in the building, 
-- unpack all containers in a building onto random floor tiles or shuffle all items in all containers

-- TODO LIST
-- forced wake up?

require "GMUtils"

GMPoltergeists = {}
GMPoltergeists.debug = false
GMPoltergeists.name = "Poltergeists"
GMPoltergeists.needScan = false
GMPoltergeists.needOnSeeNewRoom = false
GMPoltergeists.needUpdate = false
GMPoltergeists.needSleepSpawn = true
GMPoltergeists.spawnWeight = 10
GMPoltergeists.meanness = 7
GMPoltergeists.initMeanness = 7
GMPoltergeists.listOfItems = nil
GMPoltergeists.ACTION = {
  {71, "Move furniture"},
  {7, "Unpack all containers"},
  {24, "Shuffle items"}
}
GMPoltergeists.MOVE_SOUNDS = {
  { 10, "GMPolMove0"},
  { 10, "GMPolMove1"},
  { 5, "GMPolMove2"},
  { 2, "GMPolMove3"}
}
GMPoltergeists.RUM_SOUNDS = {
  { 2, "GMPolRum0"},
  { 5, "GMPolRum1"},
  { 10, "GMPolRum2"}
}
GMPoltergeists.SOUNDS = {
  { 5, "GMPol0"},
  { 10, "GMPol1"}
}

GMPoltergeists.getSound = function()
  GMUtils.debug = GMPoltergeists.debug
  return GMUtils.weightedRandom(GMPoltergeists.SOUNDS)  
end

function GMPoltergeists.obtain(which, object, listOfFurniture)
  if which == "Move furniture" then 
    GMPoltergeists.grabFurniture(object, listOfFurniture)
  else
    GMPoltergeists.grabContainer(object, listOfFurniture)
  end
end

function GMPoltergeists.doIt(which, object, to)
  if which == "Move furniture" then 
    return GMPoltergeists.move(object, to)
  elseif which == "Unpack all containers" then
    return GMPoltergeists.unpack(object, to)
  else
    return GMPoltergeists.shuffle(object)
  end
end

function GMPoltergeists.grabContainer(object, listOfFurniture)
  if object and object:getContainerCount() > 0 and object:getContainer() and object:getContainer():getItems() and object:getContainer():getItems():size() > 0 then
    table.insert(listOfFurniture, object)
    if GMPoltergeists.debug then 
      local spriteName = "UNNAMED"
      local sprite = object:getSprite()
      if sprite then
        spriteName = sprite:getName()
      end      
      print("GM Poltergeists: Grabbing container: Sprite name ", spriteName) 
      local acceptItemFunction = object:getContainer():getAcceptItemFunction()
      print("GM Poltergeists: Grabbing container: Accept Item Function ", acceptItemFunction) 
    end
  end
end

function GMPoltergeists.grabFurniture(object, listOfFurniture)
  if not object then return end
  local chairPattern = "^furniture_seating"
  local tablePattern = "^furniture_table"
  local tableTrash = "^trashcontainers"
  
  local sprite = object:getSprite()
  if sprite then
    local spriteName = sprite:getName()        
    if spriteName then
      local spriteGrid = sprite:getSpriteGrid()
    
      if not spriteGrid then
        --get only objects that is on one square
        if listOfFurniture and spriteName and (string.find(spriteName, chairPattern) or string.find(spriteName, tablePattern) or string.find(spriteName, tableTrash)) then
          table.insert(listOfFurniture, object)
          if GMPoltergeists.debug then print("GM Poltergeists: Grabbing furniture: ", spriteName) end
        end
      end
    end
  end
end

function GMPoltergeists.shuffle(object)  
  GMPoltergeists.gatherItems(object:getContainer())
  return 0.25
end

function GMPoltergeists.playOpenCloseSound(container, open)
  local sound = nil
  if open then
    sound = container:getOpenSound()
  else
    sound = container:getCloseSound()
  end
  
  if sound then 
    getSoundManager():PlayWorldSound(sound, false, container:getParent():getSquare(), 0.2, 60, 0.5, false)
  end
end


function GMPoltergeists.gatherItems(container)
  if not container or not container:getParent() then return end
  GMPoltergeists.playOpenCloseSound(container, true)
  
  local items = container:getItems()
  local size = items:size() 
  if size > 0 then
    GMUtils.debug = GMPoltergeists.debug
    local which = GMUtils.weightedRandom(GMPoltergeists.RUM_SOUNDS)
    getSoundManager():PlayWorldSound(which, false, container:getParent():getSquare(), 0.2, 60, 0.5, false)    
  end
  for i = size - 1, 0, -1 do
    local item = items:get(i)
    local itemName = item:getName()
    if itemName ~= nil then
      itemName = "UNNAMED"
    end
    table.insert(GMPoltergeists.listOfItems, item)
    if GMPoltergeists.debug then print('GM Poltergeists: Shuffle item (' .. i .. ') name: ' .. tostring(item:getName() or 'nil') .. ' display name: ' .. tostring(item:getDisplayName() or 'nil') .. ' category: ' .. tostring(item:getCategory() or 'nil')) end
    if item:getCategory() == "Container" then
      -- unpack containers
      GMPoltergeists.gatherItems(item:getInventory())
    end
    container:Remove(item)
  end
  
  GMPoltergeists.playOpenCloseSound(container, false)
end

function GMPoltergeists.unpack(object, to)
  GMPoltergeists.unpackContainer(object:getContainer(), to)
end

function GMPoltergeists.unpackContainer(container, to)
  if not container then return end
  GMPoltergeists.playOpenCloseSound(container, true)
  local items = container:getItems()
  local size = items:size() 
  if size > 0 then
    GMUtils.debug = GMPoltergeists.debug
    local which = GMUtils.weightedRandom(GMPoltergeists.RUM_SOUNDS)
    getSoundManager():PlayWorldSound(which, false, to, 0.2, 60, 0.5, false)
  end
  
  for i = size - 1, 0, -1 do
    local item = items:get(i)
    if GMPoltergeists.debug then print('GM Poltergeists: Removing item (' .. i .. ') name: ' .. tostring(item:getName() or 'nil') .. ' display name: ' .. tostring(item:getDisplayName() or 'nil') .. ' category: ' .. tostring(item:getCategory() or 'nil')) end
    if item:getCategory() == "Container" then
      -- unpack containers
      GMPoltergeists.unpackContainer(item:getInventory(), to)
    end
    to:AddWorldInventoryItem(item, 0, 0, 0)
    container:Remove(item)
  end
  GMPoltergeists.playOpenCloseSound(container, false)
  return 0.5
end

-- Return sanityMultiplier per piece of furniture moved
function GMPoltergeists.move(object, to)
  local from = object:getSquare()
  
  local containerCount = object:getContainerCount()
  local containers = {}
  for i = 0, containerCount - 1, 1 do
    table.insert(containers, object:getContainerByIndex(i))
  end
  
  -- Old object from
  local sprite = object:getSprite()
  local spriteName = sprite:getName()
  --local itemScriptName = object:getScriptName()
  if not spriteName then return end
    
  local item = instanceItem("Moveables." .. spriteName)
  if item then
    if object:getModData() and object:getModData().movableData then
      item:getModData().movableData = copyTable(object:getModData().movableData)
    end
  end
  
  triggerEvent("OnObjectAboutToBeRemoved", object)
  from:transmitRemoveItemFromSquare(object)
  from:RecalcProperties()
  from:RecalcAllWithNeighbours(true)
  IsoGenerator.updateGenerator(from)
  object:removeFromSquare()
  
  -- New object to
  local newObject = IsoObject.new(getCell(), to, getSprite(spriteName))
  if not newObject then return end
  newObject:setSquare(to)
  
  if containerCount > 0 and #containers > 0 then
    if containerCount >= 1 and #containers >= 1 then
      newObject.setContainer(containers[1])
    end
    if containerCount >= 2 and #containers >= 2 then
      newObject.addSecondaryContainer(containers[2])
    end
  end
  
  if item and item:hasModData() and item:getModData().movableData then
    newObject:getModData().movableData = copyTable(item:getModData().movableData);
  end
  
  to:AddSpecialObject(newObject)
  if isClient() then newObject:transmitCompleteItemToServer(); end
  triggerEvent("OnObjectAdded", newObject)
  getTileOverlays():fixTableTopOverlays(to)
  to:RecalcProperties()
  to:RecalcAllWithNeighbours(true)
  triggerEvent("OnContainerUpdate")
  IsoGenerator.updateGenerator(to)
  
  GMUtils.debug = GMPoltergeists.debug
  local which = GMUtils.weightedRandom(GMPoltergeists.MOVE_SOUNDS)
  getSoundManager():PlayWorldSound(which, false, to, 0.2, 60, 0.5, false)
  return 1.0
end

function GMPoltergeists.compItems(a, b)
  return a:getName() < b:getName()
end

function GMPoltergeists.doObtain(roomDefs, listOfFurniture, which)
  local size = roomDefs:size()
  if GMPoltergeists.debug then print("GM Poltergeists: The number of roomDefs in building ", size) end
  for i = 0, size - 1, 1 do
    local roomDef = roomDefs:get(i)
    if roomDef then
      if GMPoltergeists.debug then print("GM Poltergeists: roomDef[" .. i .. "] ", roomDef:getName()) end
      local isoRoom = roomDef:getIsoRoom()
      if isoRoom then
        if GMPoltergeists.debug then print("GM Poltergeists: room[" .. i .. "] ", isoRoom:getName()) end
        local squares = isoRoom:getSquares()
        local sqSize = squares:size()
        if GMPoltergeists.debug then print("GM Poltergeists: squares in room[" .. i .. "] ", sqSize) end
        for j = 0, sqSize - 1 do
          local square = squares:get(j)
          local objects = square:getObjects()
          local oSize = objects:size()
          if GMPoltergeists.debug then print("GM Poltergeists: objects in square[" .. i .. ", " .. j .. "] ", oSize) end
          for k = 0, oSize - 1 do
            local object = objects:get(k)
            GMPoltergeists.obtain(which, object, listOfFurniture)
          end
        end
      else
        if GMPoltergeists.debug then print("GM Poltergeists: isoRoom is nil") end
      end
    else
      if GMPoltergeists.debug then print("GM Poltergeists: roomDef is nil") end
    end    
    if GMPoltergeists.debug then print("GM Poltergeists: Furniture to move in room[" .. i .. "] ", #listOfFurniture) end
  end
end

-- 1. Move funiture
-- 1.1. Try to put the object/Furniture in a random room, random free square
-- 1.2. We will try 5 times then give up, no objects lost
-- 2. Unpack containers
-- 2.1. Try to put all the items of an object/container in a random room, random free square
-- 2.2. We will try 5 times then give up, no items lost or removed from container if we could not place it on the floor (free square)
-- 3. Shuffle items
-- 3.1. Get all the items from all cotainers and put it in a table (Remove from container)
-- 3.2. Sort items by getName - OCD Poltergeist
-- 3.3. Start filling up the containers
-- 3.4. We will try 5 times to do this, then give up and put all items left over on the first random square
function GMPoltergeists.doDoIt(roomDefs, listOfFurniture, which)
  local tries = 5
  local sanityMultiplier = 0.0
  while((tries > 0) and (#listOfFurniture > 0)) do
    tries = tries - 1
    for i = #listOfFurniture, 1, -1 do
      local furniture = listOfFurniture[i]
      if which == "Shuffle items" then
        sanityMultiplier = sanityMultiplier + GMPoltergeists.doIt(which, furniture, nil)
      else
        -- random room
        local roomDef = roomDefs:get(ZombRand(roomDefs:size()))
        if roomDef then
          if GMPoltergeists.debug then print("GM Poltergeists: processing containers roomDef[" .. i .. "] ", roomDef:getName()) end
          local isoRoom = roomDef:getIsoRoom()
          if isoRoom then
            local to = isoRoom:getRandomFreeSquare()
            if to ~= nil then
              sanityMultiplier = sanityMultiplier + GMPoltergeists.doIt(which, furniture, to) 
              table.remove(listOfFurniture, i)
              isoRoom:refreshSquares()
            end
          end
        end
      end
    end
  end
  
  if sanityMultiplier == 0.0 then
    sanityMultiplier = 0.1
  elseif sanityMultiplier > 10.0 then
    sanityMultiplier = 10.0
  end
  return sanityMultiplier
end

function doShuffleItems(roomDefs, listOfFurniture)
  table.sort(GMPoltergeists.listOfItems, GMPoltergeists.compItems)
  local tries = 5
  while((tries > 0) and (#GMPoltergeists.listOfItems > 0)) do
    tries = tries - 1
    for i = 1, #listOfFurniture do
      local furniture = listOfFurniture[i]
      for j = #GMPoltergeists.listOfItems, 1, -1 do
        local item = GMPoltergeists.listOfItems[j]
        local didAdd = furniture:AddItemBlind(item)
        if didAdd == nil then
          break -- container is full
        end
        table.remove(GMPoltergeists.listOfItems, j)
      end
    end              
  end
  tries = 5
  while((tries > 0) and (#GMPoltergeists.listOfItems > 0)) do
    tries = tries - 1  
    local roomDef = roomDefs:get(ZombRand(roomDefs:size()))
    if roomDef then
      if GMPoltergeists.debug then print("GM Poltergeists: processing containers roomDef ", roomDef:getName()) end
      local isoRoom = roomDef:getIsoRoom()
      if isoRoom then
        local to = isoRoom:getRandomFreeSquare()
        if to ~= nil then
          for j = #GMPoltergeists.listOfItems, 1, -1 do
            to:AddWorldInventoryItem(GMPoltergeists.listOfItems[j], 0, 0, 0)
          end
          GMPoltergeists.listOfItems = {}
        end
      end  
    end
  end
  if #GMPoltergeists.listOfItems > 0 then
    if GMPoltergeists.debug then print("GM Poltergeists: items lost ", #GMPoltergeists.listOfItems) end
  end 
  return 0.25
end


GMPoltergeists.spawn = function(player)
  if player:isInARoom() then
    GMPoltergeists.listOfItems = nil
    GMUtils.debug = GMPoltergeists.debug
    local which = GMUtils.weightedRandom(GMPoltergeists.ACTION)
    if which == "Shuffle items" then
      GMPoltergeists.listOfItems = {}
    end    
    if GMPoltergeists.debug then print("GM Poltergeists: Player is in a room") end  
    local buildingDef = player:getCurrentBuildingDef()
    if buildingDef then
      if GMPoltergeists.debug then print("GM Poltergeists: buildingDef") end
      local roomDefs = buildingDef:getRooms()
      if roomDefs then
        local listOfFurniture = {}
        GMPoltergeists.doObtain(roomDefs, listOfFurniture, which)
        local sanityMultiplier = GMPoltergeists.doDoIt(roomDefs, listOfFurniture, which)
        if which == "Shuffle items" then
          doShuffleItems(roomDefs, listOfFurniture)
        end
        --change stats
        GMSanity.updateStats(player, GMPoltergeists.meanness, sanityMultiplier)
      else
        if GMPoltergeists.debug then print("GM Poltergeists: roomDefs is nil") end
      end  
    else
      if GMPoltergeists.debug then print("GM Poltergeists: buildingDef is nil") end
    end       
  else
    if GMPoltergeists.debug then print("GM Poltergeists: Player is not in a room or vehicle") end 
  end
end

function GMPoltergeists.daily(insanityFactor)
  local factor = 1/5
  GMPoltergeists.meanness = GMUtils.changeMeanness(insanityFactor, GMPoltergeists.initMeanness, GMPoltergeists.meanness, factor)
  -- Poltergeists gets more agro as the days goes by +- 10 days till max
  if GMPoltergeists.ACTION[1][1] > 7 then
    GMPoltergeists.ACTION[1][1] = GMPoltergeists.ACTION[1][1] - 7
  end
  
  if GMPoltergeists.ACTION[2][1] < 71 then
    GMPoltergeists.ACTION[2][1] = GMPoltergeists.ACTION[2][1] + 7
  end
  
  if GMPoltergeists.ACTION[3][1] > 7 then
    GMPoltergeists.ACTION[3][1] = GMPoltergeists.ACTION[3][1] - 2
  end
end