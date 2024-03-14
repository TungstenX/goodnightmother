-- TODO LIST
-- forced wake up?

GMNaked = GMNaked or {}
GMNaked.debug = false
GMNaked.needScan = false
GMNaked.needOnSeeNewRoom = false
GMNaked.needUpdate = false
GMNaked.needSleepSpawn = true
GMNaked.spawnWeight = 10
GMNaked.meanness = 2
GMNaked.initMeanness = 2

function GMNaked.rummage(currentSquare, itemContainer)
  if itemContainer then
    local items = itemContainer:getItems()
    local size = items:size() 
    for i = size - 1, 0, -1 do
      local item = items:get(i)
      if item ~= nil then
        if not item:isFavorite() then
          if GMNaked.debug then print('GM Naked: Removing item (' .. i .. ') name: ' .. tostring(item:getName() or 'nil') .. ' display name: ' .. tostring(item:getDisplayName() or 'nil') .. ' category: ' .. tostring(item:getCategory() or 'nil')) end
          if item:getCategory() == "Container" then
            -- unpack containers
            GMNaked.rummage(currentSquare, item:getInventory())
          end
          currentSquare:AddWorldInventoryItem(item, 0, 0, 0)
          itemContainer:Remove(item)
        end
      end
    end
  end
end

GMNaked.unspawn = function(player)
  GMSanity.updateStats(player, GMNaked.meanness, 10)
end

-- Remove all items from the player
-- Be nice, ah, check for isFavorite()
GMNaked.spawn = function(player)
  local currentSquare = nil
  local roomDef = player:getCurrentRoomDef()
  if roomDef then
    local isoRoom = roomDef:getIsoRoom()
    if isoRoom then
      currentSquare = isoRoom:getRandomFreeSquare()
      if not currentSquare then
        currentSquare = isoRoom:getRandomSquare()
      end
    end
  end
  if not currentSquare then
    local x, y, z = player:getX(), player:getY(), player:getZ()
    x = x + ZombRand(-2, 3)
    y = y + ZombRand(-2, 3)
    currentSquare = getSquare(x, y, z) 
  end
  
  local container = player:getInventory()
  
  -- Drop items in player's hands
  player:dropHandItems()
  
  -- Unattaching attached items
  local attachedItems = player:getAttachedItems()
  if attachedItems ~= nil then
    if GMNaked.debug then print('GM Nake: Begin attached items count: ' .. attachedItems:size()) end
    local size = attachedItems:size() 
    for i = size - 1, 0, -1 do
      local attachedItem = attachedItems:get(i)
      if attachedItem ~= nil then
        local item = attachedItem:getItem()
        if item ~= nil then
          if not item:isFavorite() then
            if GMNaked.debug then print('GM Nake: Unattaching attached item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end
            player:removeAttachedItem(item)
          elseif GMNaked.debug then 
            print('GM Nake: Leave alone favorite attached item (' .. i .. ') display name: ', item:getDisplayName() or 'nil')        
          end
        end
      end
    end  
    if GMNaked.debug then print('GM Nake: End attached items count: ' .. player:getWornItems():size()) end  
  end
  
  -- Undress worn items
  local wornItems = player:getWornItems()
  if wornItems ~= nil then
    if GMNaked.debug then print('GM Nake: Begin worn items count: ' .. wornItems:size()) end
    local size = wornItems:size()
    for i = size - 1, 0, -1 do
      local wornItem = wornItems:get(i)
      if wornItem ~= nil then
        local item = wornItem:getItem()
        if item ~= nil then
          if not item:isFavorite() then
            if GMNaked.debug then print('GM Nake: Undressing worn item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end
            player:removeWornItem(item)
          elseif GMNaked.debug then 
            print('GM Nake: Leave alone favorite worn item (' .. i .. ') display name: ', item:getDisplayName() or 'nil')
          end
        end
      end
    end  
    if GMNaked.debug then print('GM Nake: End worn items count: ' .. player:getWornItems():size()) end
  end
  
  -- Dropping all non-favorite items to the floor
  GMNaked.rummage(currentSquare, container)
  if GMNaked.debug then print('GM Nake: End items count: ', container:getItems():size()) end
end

function GMNaked.daily(insanityFactor)
  local factor = 0.75/5
  GMNaked.meanness = GMUtils.changeMeanness(insanityFactor, GMNaked.initMeanness, GMNaked.meanness, factor)
end