-- TODO LIST
-- Properly place corpse
-- How to react for Sleep inARoom, vehicle, Tent etc

GMCorpse = GMCorpse or {}
GMCorpse.debug = false
GMCorpse.needScan = false
GMCorpse.needOnSeeNewRoom = false
GMCorpse.needUpdate = false
GMCorpse.needSleepSpawn = true
GMCorpse.spawnWeight = 10
GMCorpse.meanness = 1
GMCorpse.initMeanness = 1


GMCorpse.unspawn = function(player)
  if GMCorpse.debug then print("GM Corpse: unspawn") end
  GMSanity.updateStats(player, GMCorpse.meanness, 10)
end

-- Return object
function GMCorpse.findBedOnSquare(square)
  if GMCorpse.debug then print("GM Corpse: findBedOnSquare") end
  if not square then
    if GMCorpse.debug then print("GM Corpse: findBedOnSquare - nil square") end
    return
  end    
  local objects = square:getObjects()
  local oSize = objects:size()
  for j = 0, oSize - 1, 1 do
    local object = objects:get(j)
    local sprite = object:getSprite()
    if sprite then
      local spriteName = sprite:getName()
      if spriteName and string.find(spriteName, "^furniture_bed") then
        if GMCorpse.debug then print("GM Corpse: findBedOnSquare found bed") end
        return object
      end
    end          
  end
  return nil
end

-- return a bed object in the room that the player is or nil
function GMCorpse.findBedInRoom(player)
  if GMCorpse.debug then print("GM Corpse: findBedInRoom") end
  local roomDef = player:getCurrentRoomDef()
  if roomDef then
    local isoRoom = roomDef:getIsoRoom()
    if isoRoom then
      local squares = isoRoom:getSquares()
      local size = squares:size()
      for i = 0, size - 1, 1 do
        local square = squares:get(i)
        local bed = GMCorpse.findBedOnSquare(square)
        if bed then
          return bed
        end
      end      
    end
  end  
  return nil  
end

GMCorpse.spawn = function(player)
  if GMCorpse.debug then print("GM GMCorpse: Spawn") end
  local bedBlock1 = player:getBed() or GMCorpse.findBedInRoom(player)
  local bedBlock2 = nil
  if GMCorpse.debug then 
    if bed and bed.object then
      print("GM GMCorpse: Spawn Start bedBlock1 (" .. bedBlock1.object:getX() .. ", " .. bedBlock1.object:getY() .. ", " .. bedBlock1.object:getZ() .. ")") 
    end
  end
  
  local dir = IsoDirections.S
  if bedBlock1 then
    local properties = bedBlock1:getProperties()
    if properties then
      if properties:getPropertyNames() then
        local facing = properties:Val("Facing")
        dir = IsoDirections.valueOf(facing)
        if GMCorpse.debug then print("GM GMCorpse: Spawn bedBlock facing = ", facing) end
        -- get other block
        local x, y, z = bedBlock1:getX(), bedBlock1:getY(), bedBlock1:getZ()
        local x1, y1 = z, y
        local x2, y2 = z, y
        if facing == "W" or facing == "E" then
          x1 = x + 1
          x2 = x - 1
        else
          y1 = y + 1
          y2 = y - 1
        end
        print("GM GMCorpse: Spawn Looking next bedBlock2a is (" .. x1 .. ", " .. y1 .. ", " .. z .. ")")
        print("GM GMCorpse: Spawn Looking next bedBlock2b is (" .. x2 .. ", " .. y2 .. ", " .. z .. ")")
        local square1 = getSquare(x1, y1, z)
        local square2 = getSquare(x2, y2, z)
        local bed1 = GMCorpse.findBedOnSquare(square1)
        local bed2 = GMCorpse.findBedOnSquare(square2)
        if bed1 then
          if GMCorpse.debug then print("GM GMCorpse: Spawn got new bed block a ") end
          if facing == "N" or facing == "W" then
            bedBlock2 = bed1  
          else
            bedBlock2 = bedBlock1
            bedBlock1 = bed1  
          end
        else
          if GMCorpse.debug then print("GM GMCorpse: Spawn got new bed block b ") end
          if facing == "N" or facing == "W" then
            bedBlock2 = bed2  
          else
            bedBlock2 = bedBlock1
            bedBlock1 = bed2  
          end
        end
      end
    end    
  end
    
  local x, y, z = player:getX(), player:getY(), player:getZ()
  if bedBlock1 then
    x, y, z = bedBlock1:getX(), bedBlock1:getY(), bedBlock1:getZ()
  else
    x = x + ZombRand(-2, 3)
    y = y + ZombRand(-2, 3)
  end
  
  local zombie = createZombie(x, y, z, nil, 0, dir)
  zombie:dressInRandomOutfit()
  zombie:DoZombieInventory()
  local body = IsoDeadBody.new(zombie, false)
  body:setX(x)
  body:setY(y)
  body:setZ(z)
  body:addToWorld()
  if bedBlock1 then
    bedBlock1:getSquare():AddSpecialObject(body)
  end
  --if bedBlock2 then
  --  bedBlock2:getSquare():AddSpecialObject(body)
  --end
end

function GMCorpse.daily(insanityFactor)
  local factor = 1/5
  GMCorpse.meanness = GMUtils.changeMeanness(insanityFactor, GMCorpse.initMeanness, GMCorpse.meanness, factor)
end