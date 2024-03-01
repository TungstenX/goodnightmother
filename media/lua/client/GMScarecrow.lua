GMScarecrow = {}

GMScarecrow.SMOKE_DURATION = 1 -- in world hours
GMScarecrow.debug = false
GMScarecrow.spawned = false
GMScarecrow.mannequinObject = nil
GMScarecrow.smokeSqaure = nil
GMScarecrow.smokeEndTime = getGameTime():getWorldAgeHours() + GMScarecrow.SMOKE_DURATION

-- Spawn a Scarecrow
function GMScarecrow.spawn(x, y, z)
  local player = getPlayer()
  local modData = player:getModData();
  
  -- Check if mannequin was spawned before - Only one nightmare Scarecrow at a time
  if modData and modData.GMScarecrow then
    local gmsc = modData.GMScarecrow
    if gmsc.spawned then
      if GMScarecrow.debug then print('GM GMScarecrow already spawned') end
      -- already spawned
      return
    end
  end
  
  -- TODO: Figure out how the sprites work
  if GMScarecrow.debug then
    local sprite = getSprite("Base.MannequinScarecrow01")
    local name = "NO-NAME"
    if sprite ~= nil then
      name = sprite:getName()
    end
    print('GM GMScarecrow Sprite: ', name) 
  end
  -- Where to put Scarecrow
  local targetSquare = getSquare(x,y,z)
  -- TODO: figure out direction to face
  local deltaX = x - player:getX()
  local deltaY = y - player:getY()
  local facingDir = "E"
  if GMScarecrow.debug then print('GM playerX = ' .. player:getX() .. ' playerX = ' .. player:getY()) end
  if GMScarecrow.debug then print('GM spawnX  = ' .. x ..             ' spawnY  = ' .. y) end
  if GMScarecrow.debug then print('GM deltaX  = ' .. deltaX ..        ' deltaY  = ' .. deltaY) end
  if GMScarecrow.debug then print('GM facing direction  = ' .. facingDir) end
  
  -- Create a Mannequin as a Scarecrow
  -- TODO: That sprite thingy
  local newMannequin = IsoMannequin.new(player:getCell(), targetSquare, getSprite("Base.MannequinScarecrow01"))  
  if GMScarecrow.debug then print('GM newMannequin(): ', tostring(newMannequin)) end
  newMannequin:setSquare(targetSquare)
  --TODO: Dress mannequin, change pose
  -- Create an instance of the item
  -- local item = InventoryItemFactory.CreateItem(itemName)
  --newMannequin:getCustomSettingsFromItem(item)
  --update direction
  newMannequin:setDir(IsoDirections[facingDir])
  -- This is not working, why?
  --newMannequin:addToWorld()
  
  for i = 1, newMannequin:getContainerCount() do
    newMannequin:getContainerByIndex(i - 1):setExplored(true);
  end
  
  -- always on top, not working
  --targetSquare:AddSpecialObject( newMannequin )
  -- Not sure about this
  if isClient() then 
    newMannequin:transmitCompleteItemToServer()
  end
  
  -- Jumping the hoops, not sure if all is needed?
  triggerEvent("OnObjectAdded", newMannequin)
  getTileOverlays():fixTableTopOverlays(targetSquare)
  targetSquare:RecalcProperties()
  targetSquare:RecalcAllWithNeighbours(true)
  triggerEvent("OnContainerUpdate")
  IsoGenerator.updateGenerator(targetSquare)
  
  -- Add to player's modData
  modData.GMScarecrow = {}
  modData.GMScarecrow.mannequinObject = newMannequin;
  modData.GMScarecrow.spawned = true;
end -- GMScarecrow.spawn

-- Unspawn (yes, not a word)
-- param: scarecrow GMScarecrow object
function GMScarecrow.unspawn(scarecrow) -- not a word
  if GMScarecrow.debug then
    return -- for now
  end
  if scarecrow.spawned and scarecrow.mannequinObject ~= nil then
    -- remove mannequin from world
    -- Remove some from square if it is still there from previous unspawn
    if scarecrow.smokeSqaure ~= nil then
      scarecrow.smokeSqaure:softClear()
      scarecrow.smokeSqaure = nil
    end
    local square = scarecrow.mannequinObject:getSquare()
    -- Add smoke to the square the scarecrow was standing on
    --square:smoke()
    -- For smoke timer
    --scarecrow.smokeEndTime = getGameTime():getWorldAgeHours() + GMScarecrow.SMOKE_DURATION;
    --scarecrow.smokeSqaure = square
    
    -- scarecrow.mannequinObject:removeFromWorld()
    -- Hack for RainCollectorBarrel, Trap, etc
    triggerEvent("OnObjectAboutToBeRemoved", scarecrow.mannequinObject) 
    -- remove from square
    square:transmitRemoveItemFromSquare(scarecrow.mannequinObject)
    -- clean up the square
    square:RecalcProperties()
    -- clean up the square's neighbours
    square:RecalcAllWithNeighbours(true)
    -- update that is related to generators, why?
    IsoGenerator.updateGenerator(square)
    -- Reset spawnability
    scarecrow.spawned = false
    scarecrow.mannequinObject = nil
  end
end

-- Is the player looking at the target?
function GMScarecrow.canSee(target, player)
    local losResult = LosUtil.lineClear(player:getCell(), player:getX(), player:getY(), player:getZ(), target:getX(), target:getY(), target:getZ(), false);
    -- MaxVisibilityDistance ?
    local losClear = tostring(losResult) ~= "Blocked"
    if losClear then
      local facing = player:isFacingObject(target, 1.0)
      if GMScarecrow.debug and facing then print ("GM line of sight and facing") end
      return facing
    end
    return false
end

-- Check what we need to do
function GMScarecrow.update(player)
  local modData = player:getModData()
  if modData and modData.GMScarecrow then
    local scarecrow = modData.GMScarecrow
    if scarecrow.spawned and scarecrow.mannequinObject ~= nil then    
      if GMScarecrow.canSee(scarecrow.mannequinObject, getPlayer()) then
        -- unspawn
        GMScarecrow.unspawn(scarecrow)
      end
    elseif scarecrow.spawned and scarecrow.mannequinObject == nil then
      -- Just in case, clean up stuff
      scarecrow.spawned = false
    elseif not scarecrow.spawned and scarecrow.mannequinObject ~= nil then  
      -- Just in case, clean up stuff
      scarecrow.mannequinObject = nil
    end
    
    -- remove smoke
    if scarecrow.smokeSqaure ~= nil and (getGameTime():getWorldAgeHours() > scarecrow.smokeEndTime) then
      scarecrow.smokeSqaure:softClear()
      scarecrow.smokeSqaure = nil
      scarecrow.smokeEndTime = nil
    end   
  end
end


--Events.OnPlayerUpdate.Add(GMScarecrow.update)
