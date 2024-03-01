require "GMDebug"
require "GMScarecrow"
require "GMNaked"
require "GMSleepWalker"

--TODO: Get windows and doors
function Test1MenuEntry()
  print("GM test 1 start") 
  GMSleepWalker.debug = isDebugMode(true)
  GMSleepWalker.spawn()
  print("GM test 1 end")
end

function Test2MenuEntry()
  print("GM test 2 start")
  local player = getPlayer()
  local x, y, z = player:getX(), player:getY(), player:getZ()
  x = x -1
  GMScarecrow.debug = isDebugMode(true)
  GMScarecrow.spawn(x, y, z)
  print("GM test 2 end")
end

function Test3MenuEntry()
  print("GM test 3 start")
  local player = getPlayer()
  local x, y, z = player:getX(), player:getY(), player:getZ()
  x = x -1
  GMNaked.debug = isDebugMode(true)
  GMNaked.spawn(x, y, z)
  print("GM test 3 end")
end

local function testContextMenu(playerIndex, context, worldObjects, test)
	context:addOption("Test 1", getSpecificPlayer(playerIndex), Test1MenuEntry)
	context:addOption("Test 2", getSpecificPlayer(playerIndex), Test2MenuEntry)
	context:addOption("Test 3", getSpecificPlayer(playerIndex), Test3MenuEntry)
end

Events.OnFillWorldObjectContextMenu.Add(testContextMenu)