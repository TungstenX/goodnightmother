-- TODO LIST
-- Update for new useage

require "GMDebug"
require "GMScarecrow" 
require "GMNaked" 
require "GMSleepWalker" 
require "GMDoors" 
require "GMCorpse" -- To test




function Test1MenuEntry()
  print("GM test 1: Start") 
  local player = getPlayer()
  
  local isoRoom = nil
  local roomDef = player:getCurrentRoomDef()
  if roomDef then
    print("GM roomDef ", roomDef:getName())
    isoRoom = roomDef:getIsoRoom()
  end
  
  --
  
  print("GM test 1: End") 
end

function Test2MenuEntry()
  print("GM test 2 start")
  GMScarecrow.debug = true
  GMScarecrow.printMannequinList()
  print("GM test 2 end")
end

function Test3MenuEntry()
  print("GM test 3 start")
  GMDoors.debug = true
  GMDoors.spawn(getPlayer())
  print("GM test 3 end")
end

function Test4MenuEntry()
  print("GM test 4 start")
  GMNaked.debug = true
  local player = getPlayer()
  local x = player:getX() + 1
  local y = player:getY() + 1
  local z = player:getZ()
  GMNaked.spawn(x, y, z)
  print("GM test 4 end")
end

function Test5MenuEntry()
  print("GM test 5 start")
  GMSleepWalker.debug = true
  GMSleepWalker.spawn(getPlayer())
  print("GM test 5 end")
end

local function testContextMenu(playerIndex, context, worldObjects, test)
	context:addOption("Test 1 - Find Radio, phone or TV", getSpecificPlayer(playerIndex), Test1MenuEntry)
	context:addOption("Test 2 - Print Scarecrow list", getSpecificPlayer(playerIndex), Test2MenuEntry)
	context:addOption("Test 3 - Do doors", getSpecificPlayer(playerIndex), Test3MenuEntry)
	context:addOption("Test 4 - Do naked", getSpecificPlayer(playerIndex), Test4MenuEntry)
	context:addOption("Test 5 - Do sleepwalker", getSpecificPlayer(playerIndex), Test5MenuEntry)
end

Events.OnFillWorldObjectContextMenu.Add(testContextMenu)