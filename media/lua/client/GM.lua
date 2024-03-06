-- ---------------- --
-- Goodnight Mother --
-- ---------------- --
require "GMUtils"
require "GMCorpse"
require "GMDoors"
require "GMNaked"
require "GMScarecrow" 
require "GMSleepWalker"
require "GMTV"

GM = {}
GM.debug = false
GM.nightmares = {GMCorpse, GMDoors, GMNaked, GMScarecrow, GMTV}
GM.forScan = {}
GM.forOnSeeNewRoom = {}
GM.forUpdate = {}
GM.forSleepSpawn = {}
GM.scanRadius = 2 -- How many squares? ((scanRadius * 2) + 1)^2
GM.busyWithSleepNightmare = false
GM.busyWithWakeNightmare = false
GM.nightmareSound = nil

-- Initialise function lists 
--  Called by OnGameStart
function GM.init()
  for i = 1, #GM.nightmares do
    local nightmare = GM.nightmares[i]
    nightmare.init()
    if nightmare.needScan then
      table.insert(GM.forScan, nightmare)
    end
    if nightmare.needOnSeeNewRoom then
      table.insert(GM.forOnSeeNewRoom, nightmare)
    end
    if nightmare.needUpdate then
      table.insert(GM.forUpdate, nightmare)
    end
    if nightmare.needSleepSpawn then
      table.insert(GM.forSleepSpawn, {nightmare.spawnWeight, nightmare})
    end
  end
end
Events.OnGameStart.Add(GM.init)

-- Scan a block of square around the player evertime they move
function GM.playerMove(player)
  local distance = scanRadius.scanRadius
  for x = player:getX() - distance, player:getX() + distance, 1 do
    for y = player:getY() - distance, player:getY() + distance, 1 do
      local square = getCell():getGridSquare(x, y, player:getZ())
      for i = 1, #GM.forScan do
        local nightmare = GM.forScan[i]
        nightmare.addFromSquare(square)
      end 
    end    
  end 
end
Events.OnPlayerMove.Add(GM.playerMove)

function GM.onSeeNewRoom(room)
  for i = 1, #GM.forScan do
    local nightmare = GM.forOnSeeNewRoom[i]
    nightmare.onSeeNewRoom(room)
  end 
end

Events.OnSeeNewRoom.Add(GM.onSeeNewRoom)

function GM.update(player)
  for i = 1, #GM.forUpdate do
    local nightmare = GM.forUpdate[i]
    nightmare.update(player)
  end 
end
Events.OnPlayerUpdate.Add(GM.update)

function GM.sleepNightmareGenerator(player)  
  local nightmare = GMUtils.weightedRandom(forSleepSpawn)
  nightmare.spawn(player)
end  

function GM.EveryTenMinutes()
  local player = getPlayer()
	local is_asleep = player:isAsleep()
  -- Asleep nightmares
	if is_asleep then
    if GM.busyWithWakeNightmare then
      GM.busyWithWakeNightmare = false
    end
    -- Do one nightmare per sleep cycle
    if not GM.busyWithSleepNightmare then
      if GM.debug then print('GM Do new sleep nightmare spawn here') end
      GM.busyWithSleepNightmare = true
      if GM.nightmareSound then
        GM.nightmareSound:stop()
        GM.nightmareSound = nil
      end
      -- TODO: Think of other sounds?
      GM.nightmareSound = getSoundManager():PlayWorldSound("GMMommy", false, player:getCurrentSquare(), 0.2, 60, 0.5, false)
      GM.sleepNightmareGenerator(player)
    end
  end
  
  -- Awake nightmares
  if not is_asleep then
    if GM.busyWithSleepNightmare then
      GM.busyWithNightmare = false
      if GM.nightmareSound then
        GM.nightmareSound:stop()
        GM.nightmareSound = nil
      end
    end
  end
end
Events.EveryTenMinutes.Add(GM.EveryTenMinutes)
