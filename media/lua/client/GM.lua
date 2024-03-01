--local SPAWNER_API = CommunityAPI.Client.Spawner
local PLAYER = nil
local PLAYER_BD = nil
local PLAYER_STATS = nil
local NIGHT_MARE_DONE = false
local MOMMY_SOUND = nil

--Initializes the player (if necessary) and their data.
local function PlayerInit()
	local player = getPlayer()
	if player == PLAYER then
		return --Already set
	end
	print('GM NEW PLAYER! ',tostring(player));  -- debug
	PLAYER = player
	PLAYER_BD = PLAYER:getBodyDamage();
	PLAYER_STATS = PLAYER:getStats();
end

--Auto Ages InventoryItems.
---@param item InventoryItem
function ageInventoryItem(item)
    if item then
        item:setAutoAge()
    end
end

--Checks and returns square if outside.
---@param square IsoGridSquare
---@return IsoGridSquare
function checkIfInside(square)
    if not square then
        return
    end
    if not square:isOutside() then
        return square
    end
end

-- Spawn a nightmare
-- Can spawn one of:
-- - Corpse 25% chance
-- - Manniquin 25% chance
-- - Wake up naked 25% chance
-- - Wake up in other bed
---@param player IsoPlayer 
function nightmareGenerator(player)
  local allNightmareItems = { "Corpse", "Manniquin", "Naked", "Other", "Windows", "None" }  
  local nightmareItem = "NONE" -- allNightmareItems[(ZombRand(#allNightmareItems) + 1)]
  
  local x, y, z = player:getX(), player:getY(), player:getZ()
  x = x + ZombRand(-2, 3)
  y = y + ZombRand(-2, 3)
  
  -- If the player is in a room then check if the random x,y is inside the same room
  -- but only when spawning corpses or manniquins
  
  local roomDef = player:getCurrentRoomDef()
  local isInRoom = player:isInARoom()
  print("GM Is player in a room " .. tostring(isInRoom))
  if isInRoom and not (nightmareItem == "Windows" or nightmareItem == "Other") then
    -- find a place in room
    local found = false
    if nightmareItem == "Corpse" then
      -- TODO: find bed x, y, z
      local square = player:getBed():getSquare()
      x = square:getX()
      y = square:getY()
    elseif nightmareItem == "Naked" then
      local square = roomDef:getIsoRoom():getRandomFreeSquare()
      x = square:getX()
      y = square:getY()
    else
      local tries = 5
      while((not roomDef:isInside(x, y, z)) and (tries > 0))
      do
        x = x + ZombRand(-2, 3)
        y = y + ZombRand(-2, 3)
        tries = tries - 1 
      end
    end
  end
  
  if nightmareItem == "Corpse" then
    local zombie = createZombie(x, y, z, nil, 0, IsoDirections.S);
    zombie:dressInRandomOutfit();
    zombie:DoZombieInventory();
    local body = IsoDeadBody.new(zombie, false);
    body:setX(x);
    body:setY(y);
    body:setZ(z);
    body:addToWorld()
  elseif nightmareItem == "Manniquin" then
    -- From Fred, need to create temp obj class to make it vanished
    local newMannequin = IsoMannequin.new(getCell(), targetSquare, getSprite(spriteName))
    newMannequin:setSquare(targetSquare)--probably useless as we just did it
    newMannequin:getCustomSettingsFromItem(item)--load from the temporary item
    newMannequin:setDir(IsoDirections[mainDirLetter]);--update direction
    for i=1,newMannequin:getContainerCount() do
      newMannequin:getContainerByIndex(i-1):setExplored(true);
    end
    targetSquare:AddSpecialObject( newMannequin )--always on top
    if isClient() then 
      newMannequin:transmitCompleteItemToServer()
    end
    triggerEvent("OnObjectAdded", newMannequin) -- for RainCollectorBarrel in singleplayer
    getTileOverlays():fixTableTopOverlays(targetSquare)
    targetSquare:RecalcProperties()
    targetSquare:RecalcAllWithNeighbours(true)
    triggerEvent("OnContainerUpdate")
    IsoGenerator.updateGenerator(targetSquare)
    -- Old code
    -- local mannequin = IsoMannequin.new(IsoCell.new(x, y))
    -- mannequin:addToWorld()
    -- local currentSquare = getSquare(x,y,z)
    -- currentSquare:AddWorldInventoryItem(mannequin, 0, 0, 0)
  elseif nightmareItem == "Naked" then
    -- roomDef:getFreeSquare() ?? To get a place to put inventory?
    -- or roomDef:getIsoRoom():getRandomFreeSquare()
    local container = player:getInventory()
    local currentSquare = getSquare(x,y,z) 
    
    player:dropHandItems()
    local items = container:getItems()
    print('GM Begin items count: ' .. items:size())
    for i = 0, items:size() -1, 1
    do
      local item = items:get(i)
      local itemDisplayName = item:getDisplayName()
      local itemName = item:getName()
      local itemType = item:getType()
      print('GM item (' .. i .. ') display name: ' .. itemDisplayName)
      print('GM item (' .. i .. ') name:         ' .. itemName)
      print('GM item (' .. i .. ') type:         ' .. itemType)
      -- print('GM item (' .. i .. ') is container: ' .. item:IsInventoryContainer())
      -- TODO, Unpack backpacks
      --if item:IsInventoryContainer() then
        -- Unpack everything in container
      --  for j = 0, item:getItems():size() -1, 1
      --  do
      --    local packedItem = item:getItems():get(j)
      --    currentSquare:AddWorldInventoryItem(packedItem, 0, 0, 0)
      --  end
      --  item:removeAllItems(packedItem)
      --end
      currentSquare:AddWorldInventoryItem(item, 0, 0, 0)
      
      if item:isEquipped() then
        -- unequip
        print('GM removeAttachedItem')
        player:removeAttachedItem(item)
      else
        print('GM DoRemoveItem')
        player:getInventory():DoRemoveItem(item)
      end      
    end
    print('GM End items count: ', items:size())
    print('Stop here')
  else -- Other
    print('GM Find bed')
    -- getFamiliarBuildings()
  end
end

--Check the player's sleep (sleeping or not sleeping), and react to changes.
function CheckSleepPlayer()
	PlayerInit()
	local is_asleep = PLAYER:isAsleep();
	if is_asleep and not NIGHT_MARE_DONE then
    print('GM Do new nightmare spawn here'); -- debug
    NIGHT_MARE_DONE = true
    MOMMY_SOUND = getSoundManager():PlayWorldSound("GMMommy", false, PLAYER:getCurrentSquare(), 0.2, 60, 0.5, false);
    nightmareGenerator(PLAYER)
  elseif is_asleep and NIGHT_MARE_DONE then
    -- print('GM Do nothing'); -- debug
  elseif not is_asleep and NIGHT_MARE_DONE then
    NIGHT_MARE_DONE = false				
    MOMMY_SOUND:stop();
		MOMMY_SOUND = nil
  end
end

-- Check if player is asleep
local lastMinute = nil
Events.OnTick.Add(function()
	local minute = getGameTime():getMinutes()
		if minute ~= lastMinute or is_asleep then
			lastMinute = minute
			CheckSleepPlayer()
	end
end)