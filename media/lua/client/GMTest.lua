require "SpawnPoints"

function Test1MenuEntry()
  print("GM do test 1")  
  print('SpawnPoints: ' .. SpawnPoints())
  print('SpawnPoints[0]: ' .. SpawnPoints()[0])
  print('SpawnPoints[0][0]: ' .. SpawnPoints()[0][0])
  print('SpawnPoints[0][0][0]: ' .. SpawnPoints()[0][0][0])  
end

function Test2MenuEntry()
  print("GM do test 2")
  local player = getPlayer()
  local targetSquare = player:getSquare()
  local newMannequin = IsoMannequin.new(player:getCell()) --, targetSquare, getSprite(spriteName)
  newMannequin:setSquare(targetSquare)--probably useless as we just did it
  --newMannequin:getCustomSettingsFromItem(item)--load from the temporary item
  --newMannequin:setDir(IsoDirections[mainDirLetter]);--update direction
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
end

function Test3MenuEntry()
  print("GM do test 3")
  local player = getPlayer()
  local bed = player:getBed()
  print('GM player bed ', bed)
  if not bed == nil then
      print('GM player bed X ', bed:getX())
      print('GM player bed Y ', bed:getY())
      print('GM player bed Z ', bed:getZ())
  end
end

local function testContextMenu(playerIndex, context, worldObjects, test)
	context:addOption("Test 1", getSpecificPlayer(player), Test1MenuEntry)
	context:addOption("Test 2", getSpecificPlayer(player), Test2MenuEntry)
	context:addOption("Test 3", getSpecificPlayer(player), Test3MenuEntry)
end

Events.OnFillWorldObjectContextMenu.Add(testContextMenu)