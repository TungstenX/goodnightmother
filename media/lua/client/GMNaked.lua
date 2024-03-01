GMNaked = {}
GMNaked.debug = false

-- Remove all items from the player
-- Be nice, ah, check for isFavorite()
function GMNaked.spawn(x, y, z)
  local player = getPlayer()
  local container = player:getInventory()
  local currentSquare = getSquare(x, y, z) 
  
  -- Drop items in player's hands
  player:dropHandItems()
  
  -- Unattaching attached items
  local attachedItems = player:getAttachedItems()
  if attachedItems ~= nil then
    if GMNaked.debug then print('GM Nake: Begin attached items count: ' .. attachedItems:size()) end
    local size = attachedItems:size() 
    for i = size - 1, 0, -1 do
      local attachedItem = attachedItem:get(i)
      if attachedItem ~= nil then
        local item = attachedItem:getItem()
        if item != nil then
          if item:isFavorite() then
            if GMNaked.debug then print('GM Nake: Unattaching attached item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end
            player:removeAttachedItem(item)
          elseif GMNaked.debug then 
            print('GM Nake: Leave alone favorite attached item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end        
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
        if item != nil then
          if item:isFavorite() then
            if GMNaked.debug then print('GM Nake: Undressing worn item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end
            player:removeWornItem(item)
          elseif GMNaked.debug then 
            print('GM Nake: Leave alone favorite worn item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end        
          end
        end
      end
    end  
    if GMNaked.debug then print('GM Nake: End worn items count: ' .. player:getWornItems():size()) end
  end
  
  -- Dropping all non-favorite items to the floor
  local items = container:getItems()
  if items ~=nil then
    if GMNaked.debug then print('GM Nake: Begin items count: ' .. items:size()) end
    local size = items:size() 
    for i = size - 1, 0, -1 do
      local item = items:get(i)
      if item ~= nil then
        if item:isFavorite() then
          if GMNaked.debug then print('GM Nake: Removing item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end
          currentSquare:AddWorldInventoryItem(item, 0, 0, 0)
          container:Remove(item)
        elseif GMNaked.debug then 
          print('GM Nake: Leave alone favorite item (' .. i .. ') display name: ', item:getDisplayName() or 'nil') end        
        end
      end
    end
    if GMNaked.debug then print('GM Nake: End items count: ', container:getItems():size()) end
  end
end