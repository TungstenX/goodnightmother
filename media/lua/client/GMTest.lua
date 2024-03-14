-- TODO LIST
-- 

require "GMDebug"
--require "GMScarecrow" 
--require "GMNaked" 
--require "GMSleepWalker" 
--require "GMDoors" 
require "GMCorpse" -- To test
--require "GMPoltergeists"


function Test1MenuEntry()
  print("GM test 1: Start") 
  local player = getPlayer()
  GMCorpse.debug = true
  --GMPoltergeists.ACTION = {
  --  {10, "Move furniture"}
  --}
  
  local startTime = 0--os.clock()
  GMCorpse.spawn(player)
  GMCorpse.unspawn(player)
  local endTime = 0--os.clock()
  
  print(string.format("GM test 1: End, Duration: %.3f", (endTime - startTime))) 
end

function Test2MenuEntry()
  print("GM test 2 start")
  local player = getPlayer()
  --GMPoltergeists.debug = true
  --GMPoltergeists.ACTION = {
  --  {10, "Shuffle items"}
  --}
  
  local startTime = 0-- os.clock()
  player:setDir(IsoDirections.E)
  player:setX(player:getX() + 1)
  --GMPoltergeists.spawn(player)
  local endTime = 0 --os.clock()
  
  print(string.format("GM test 2: End, Duration: %.3f", (endTime - startTime)))
end

function Test3MenuEntry()
  print("GM test 3 start")
  local player = getPlayer()
  GMPoltergeists.debug = true
  GMPoltergeists.ACTION = {
    {10, "Unpack all containers"}
  }
  
  local startTime = os.clock()
  --GMPoltergeists.spawn(player)
  local endTime = os.clock()
  
  print(string.format("GM test 3: End, Duration: %.3f", (endTime - startTime)))
end

function printObject(object)
  
  print("\tObject")
  if not object then
    print("\t\tNo Object")
    return
  end
  print("\t\tName:         ", object:getName())
  print("\t\tObject Index: ", object:getObjectIndex())
  print("\t\tObject Name:  ", object:getObjectName())
  local properties = object:getProperties()
  if properties then
    print("\t\tProperties")  
    if properties:getFlagsList() then
      print("\t\t\tFlags List")  
      for i = 0, properties:getFlagsList():size() - 1, 1 do
        local flag = properties:getFlagsList():get(i)
        print("\t\t\t\tFlag: ", flag:toString())  
      end
    end
    print("\t\t\tItem height:       ", properties:getItemHeight())
    if properties:getPropertyNames() then
      print("\t\t\tProperty names") 
      for i = 0, properties:getPropertyNames():size() - 1, 1 do
        print("\t\t\t\tName: " .. properties:getPropertyNames():get(i) .. " = " .. properties:Val(properties:getPropertyNames():get(i)))  
      end
    end
    print("\t\t\tis Surface Offset: ", properties:isSurfaceOffset())
    print("\t\t\tis Table:          ", properties:isTable())
    print("\t\t\tis Table Top:      ", properties:isTableTop())
  end
  
  print("\t\tScript Name:           ", object:getScriptName())
  print("\t\tSpecial Object Index:  ", object:getSpecialObjectIndex())
  local sprite = object:getSprite()
  if sprite then
    print("\t\tSprite Name:           ", object:getSprite():getName())
  end  
  print("\t\tType:                  ", object:getType())
  print("\t\tWorld Object Index:    ", object:getWorldObjectIndex())
  print("\t\tis Exist In The World: ", object:isExistInTheWorld())
  
end


function Test4MenuEntry()
  print("GM test 4 start")
  local player = getPlayer()
  local sq0 = player:getCurrentSquare()
  local sqXP1 = getSquare(sq0:getX() + 1, sq0:getY(), sq0:getZ())
  local sqXM1 = getSquare(sq0:getX() - 1, sq0:getY(), sq0:getZ())
  local sqYP1 = getSquare(sq0:getX(), sq0:getY() + 1, sq0:getZ())
  local sqYM1 = getSquare(sq0:getX(), sq0:getY() - 1, sq0:getZ())
  local sqs = {
    {"SQ 000", sq0},
    {"SQ X+1", sqXP1},
    {"SQ X-1", sqXM1},
    {"SQ Y+1", sqYP1},
    {"SQ Y-1", sqYM1},
  }
  for k,v in pairs(sqs) do
    local roomName = "NOT ROOM"
    local isoRoom = v[2]:getRoom()
    if isoRoom then 
      roomName = isoRoom:getName()
    end    
    print(v[1] .. " " .. roomName)  
    for i = 0, v[2]:getObjects():size() - 1, 1 do
      printObject(v[2]:getObjects():get(i))
    end
  end  
  print("GM test 4 end")
end

function everyTenMinutes()
 local player = getPlayer()
  --change stats
  meanness = 9
  local maxHoursToSleep = meanness + ((2*(10 - meanness))-7)
  player:getStats():setStress(player:getStats():getStress() + (meanness / 180.0))
  player:getStats():setPanic(player:getStats():getPanic() + (meanness * 2.5))
  player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + (meanness * 0.5))
  player:getStats():setSanity(player:getStats():getSanity() - (meanness / 360.0))
  player:getStats():setMorale(player:getStats():getMorale() - (meanness / 360.0))
end

function Test5MenuEntry()
  print("GM test 5 start")
  Events.EveryTenMinutes.Remove(everyTenMinutes)
  Events.EveryTenMinutes.Add(everyTenMinutes)
  print("GM test 5 end")
end

local function testContextMenu(playerIndex, context, worldObjects, test)
	context:addOption("Test 1 - Corpse final test", getSpecificPlayer(playerIndex), Test1MenuEntry)
	context:addOption("Test 2 - Poltergeists Shuffle", getSpecificPlayer(playerIndex), Test2MenuEntry)
	context:addOption("Test 3 - Poltergeists Unpack", getSpecificPlayer(playerIndex), Test3MenuEntry)
	context:addOption("Test 4 - Scan player squares", getSpecificPlayer(playerIndex), Test4MenuEntry)
	context:addOption("Test 5 - Change every 10", getSpecificPlayer(playerIndex), Test5MenuEntry)
end

Events.OnFillWorldObjectContextMenu.Add(testContextMenu)