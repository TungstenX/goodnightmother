-- TODO LIST
-- Unspawn scarecrow after x amount of time?
-- Effect when unspawning

require "GMUtils"

GMScarecrow = {}
GMScarecrow.debug = false

GMScarecrow.needScan = true
GMScarecrow.needOnSeeNewRoom = false
GMScarecrow.needUpdate = true
GMScarecrow.needSleepSpawn = true
GMScarecrow.spawnWeight = 10

GMScarecrow.MannequinList = {}
GMScarecrow.ScanDistance = 2 -- in squares, thus block of sqr((2 * ScanDistance) + 1). E.g. sqr((2 * 2) + 1) = sqr(5) = 25
GMScarecrow.SCRIPTS = {
  {7, "FemaleBlack02"},        -- 7%
  {7, "MaleBlack02"},          -- 7%
  {7, "FemaleWhite03"},        -- 7%
  {7, "MaleWhite03"},          -- 7%
  {31, "MannequinSkeleton01"}, -- 31%
  {41, "MannequinScarecrow01"} -- 41%
}

-- Do nothing
GMScarecrow.init = function()
end

-- Add object to Mannequin List if it is not already in the list
-- param object should be an IsoMannequin
function GMScarecrow.AddToList(object)
  for i = 1, #GMScarecrow.MannequinList do
    if GMScarecrow.MannequinList[i] == object then return end -- don't add duplicates
  end
  table.insert(GMScarecrow.MannequinList, object)    
  if GMScarecrow.debug then print("GM Scarecrow: adding mannequin to list") end
end

-- Add tagged objects (IsoMannequins) to MannequinList
-- param square IsoGridSquare
GMScarecrow.addFromSquare = function(square)
  if not square then return end--handles teleport
  local objects = square:getObjects()
  for i = 0, objects:size() - 1 do
    local object = objects:get(i)
    if object:hasModData() then
      local md = object:getModData()
      if md.GMScarecrow then
        GMScarecrow.AddToList(object)
      end
    end
  end
end

-- Scan a block of squares around the player for tagged objects 
function GMScarecrow.addFromAroundPlayer(player)
  local distance = GMScarecrow.ScanDistance
  for x = player:getX() - distance, player:getX() + distance, 1 do
    for y = player:getY() - distance, player:getY() + distance, 1 do
      local square = getCell():getGridSquare(x, y, player:getZ())
      GMScarecrow.addFromSquare(square)
    end    
  end
end

-- Rotate the Scarecrow to always face the player
GMScarecrow.update = function(player)
  if GMScarecrow.MannequinList then
    local pVector = Vector2.new(player:getX(), player:getY())
    for i = 1, #GMScarecrow.MannequinList do
      local scarecrow = GMScarecrow.MannequinList[i]
      if scarecrow ~= nil then
        local sVector = Vector2.new(scarecrow:getX(), scarecrow:getY())
        local angle = sVector:angleTo(pVector)
        if angle >= -0.3926990817 and angle < 0.3926990817 then -- [-22.5 to 22.5)
          scarecrow:rotate(IsoDirections.E)
        elseif angle >= 0.3926990817 and angle < 1.1780972451 then -- [22.5 to 67.5)
          scarecrow:rotate(IsoDirections.SE)
        elseif angle >= 1.1780972451 and angle < 1.9634954085 then -- [67.5 to 112.5)
          scarecrow:rotate(IsoDirections.S)
        elseif angle >= 1.9634954085 and angle < 2.7488935719 then -- [112.5 to 157.5)
          scarecrow:rotate(IsoDirections.SW)
        elseif angle >= -1.1780972451 and angle < -0.3926990817 then -- [-67.5 to -22.5)
          scarecrow:rotate(IsoDirections.NE)
        elseif angle >= -1.9634954085 and angle < -1.1780972451 then -- [-112.5 to -67.5)
          scarecrow:rotate(IsoDirections.N)
        elseif angle >= -2.7488935719 and angle < -1.9634954085 then -- [-157 to -112.5)
          scarecrow:rotate(IsoDirections.NW)
        else -- [22.5 to 67.5)
          scarecrow:rotate(IsoDirections.W)
        end
      end
    end
  end
end

-- Find a randomSquare
-- param roomDef can be nil
function GMScarecrow.findARandomSquare(player, roomDef)
  local tries = 5
  local x = player:getX() + ZombRand(-2, 3)
  local y = player:getY() + ZombRand(-2, 3)
  local z = player:getZ()
  
  while ((roomDef ~= nil) and (tries > 5) and not roomDef:isInside(x, y, z)) do
    x = player:getX() + ZombRand(-2, 3)
    y = player:getY() + ZombRand(-2, 3)
    tries = tries - 1
  end
  return getSquare(x, y, z)
end

-- find a square for spawning
function GMScarecrow.findASquare(player)
  local roomDef = nil
  if player:isInARoom() then
    local roomDef = player:getCurrentRoomDef()
    if roomDef then
      local square = roomDef:getFreeSquare()
      if square then
        return square
      end
    end
  end
  -- could not find square
  return GMScarecrow.findARandomSquare(player, roomDef)    
end

-- Spawn a Scarecrow
GMScarecrow.spawn = function(player)
  if GMScarecrow.debug then print("GM Scarecrow: Spawning mannequin") end
  local script = GMUtils.weightedRandom(GMScarecrow.SCRIPTS)
  if GMScarecrow.debug then print("GM Scarecrow: Using script: ", script) end
  local targetSquare = GMScarecrow.findASquare(player)
  
  --TODO: Test others sprite names
  local spriteName = "location_shop_mall_01_69"
  local item = instanceItem("Moveables." .. spriteName)
  
  local newMannequin = IsoMannequin.new(getCell(), targetSquare, getSprite(spriteName))
  newMannequin:setSquare(targetSquare)
  --TODO: Maybe update settings here?
  newMannequin:getCustomSettingsFromItem(item)  
  newMannequin:setMannequinScriptName(script)
  --Not sure what this does
  for i = 1, newMannequin:getContainerCount() do
    newMannequin:getContainerByIndex(i - 1):setExplored(true);
  end
  --This is probaly not working
  if newMannequin and item and item:hasModData() and item:getModData().movableData then
    newMannequin:getModData().movableData = copyTable(item:getModData().movableData);
  end
  --always on top
  targetSquare:AddSpecialObject(newMannequin);
  if isClient() then newMannequin:transmitCompleteItemToServer(); end
  -- for RainCollectorBarrel in singleplayer
  triggerEvent("OnObjectAdded", newMannequin) 
  getTileOverlays():fixTableTopOverlays(targetSquare);
  targetSquare:RecalcProperties();
  targetSquare:RecalcAllWithNeighbours(true);
  triggerEvent("OnContainerUpdate")
  IsoGenerator.updateGenerator(targetSquare)
    
  -- timestamp movement
  local md = newMannequin:getModData();
  md.GMScarecrow = {}
  GMScarecrow.AddToList(newMannequin);
end -- GMScarecrow.spawn

function GMScarecrow.printMannequinList()  
  if GMScarecrow.debug then
    print("GM Scarecrow: Mannequin List start")
    local count = 0
    for i = 1, #GMSC.MannequinList do
      local scarecrow = GMSC.MannequinList[i];
      if scarecrow ~= nil then 
        print("GM Scarecrow: Mannequin[" .. i .. "]: ", tostring(scarecrow))
        count = count + 1
      else
        print("GM Scarecrow: Mannequin[" .. i .. "]: IS NIL")
      end
    end
    print("GM Scarecrow: Mannequins in list: ", tostring(count))
    print("GM Scarecrow: Mannequin List end")
  end
end
