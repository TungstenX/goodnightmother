-- ---------------- --
-- Goodnight Mother --
-- ---------------- --

-- Sleep Meanness (0-9)  0 = annoying, 9 = "Really!?! WTF!"
-- GMNightNoises  = 0 - Do nothing, just play eerie sounds when a player while a player is asleep 
-- GMCorpse       = 1 - Place a corps near a player when sleeping
-- GMDoors        = 5 - Open all closed doors and windows, Close all open doors and windows
-- GMNaked        = 2 - Force unequipe and drop all inventory items on the floor when a player sleeps
-- GMPoltergeists = 1 - When a player sleeps; move furniture around in the building
--                = 2 - When a player sleeps; Shuffle all items in all containers in a building
--                = 9 - When a player sleeps; Unpack all items from all containers in a building
-- GMSleepWalker  = 2 - Teleport a player to another room when they sleep, same building

-- Wake Meanness (0-9)  0 = annoying, 9 = "Really!?! WTF!"
-- GMDayNoises    = 0 - Do nothing, just play eerie sounds when a player is moving in different areas
-- GMTV           = 1 - Play radio sounds (once per device) when a player enter a room with a radio
--                = 1 - Play phone ring sounds (once per device) when a player enter a room with a ???
--                = 1 - Play doorbell ring sounds (once per device) when a player enter a room with a ???
--                = 9 - Spawn Samara when player face TV (once per device)

-- Meannes translated to spawnWeight

require "GMUtils"
require "GMCorpse"
require "GMDoors"
require "GMNaked"
require "GMNightNoises"
require "GMScarecrow" 
require "GMSleepWalker"
require "GMPoltergeists"
require "GMTV"

GM = GM or {}
GM.debug = true
GM.nightmares = {}
GM.forScan = {}
GM.forOnSeeNewRoom = {}
GM.forUpdate = {}
GM.forSleepSpawn = {}
GM.scanRadius = 2 -- How many squares? ((scanRadius * 2) + 1)^2
GM.busyWithSleepNightmare = false
GM.busyWithWakeNightmare = false
GM.nightmareSound = nil
GM.sleepNightmare = nil
GM.wakeNightmare = nil
GM.daysRunning = 0

-- Initialise function lists 
--  Called by OnGameStart
function GM.init()
  GM.nightmares = {} --resetting
  if GM.Options.corpseEnabled then
    GMCorpse.initMeanness = GM.Options.corpseMeanness
    GMCorpse.meanness = GM.Options.corpseMeanness
    table.insert(GM.nightmares, GMCorpse)
  end
  if GM.Options.devicesEnabled then
    GMTV.initMeanness = GM.Options.devicesMeanness
    GMTV.meanness = GM.Options.devicesMeanness
    table.insert(GM.nightmares, GMTV)
  end
  if GM.Options.nakedEnabled then
    GMNaked.initMeanness = GM.Options.nakedMeanness
    GMNaked.meanness = GM.Options.nakedMeanness
    table.insert(GM.nightmares, GMNaked)
  end
  if GM.Options.nightNoisesEnabled then
    GMNightNoises.initMeanness = GM.Options.nightNoisesMeanness
    GMNightNoises.meanness = GM.Options.nightNoisesMeanness
    table.insert(GM.nightmares, GMNightNoises)
  end
  if GM.Options.poltergeistsEnabled then
    GMDoors.initMeanness = GM.Options.poltergeistsMeanness
    GMDoors.meanness = GM.Options.poltergeistsMeanness
    table.insert(GM.nightmares, GMDoors)
    GMPoltergeists.initMeanness = GM.Options.poltergeistsMeanness
    GMPoltergeists.meanness = GM.Options.poltergeistsMeanness
    table.insert(GM.nightmares, GMPoltergeists)
  end
  if GM.Options.scarecrowEnabled then
    GMScarecrow.initMeanness = GM.Options.scarecrowMeanness
    GMScarecrow.meanness = GM.Options.scarecrowMeanness
    table.insert(GM.nightmares, GMScarecrow)
  end
  if GM.Options.sleepWalkerEnabled then
    GMSleepWalker.initMeanness = GM.Options.sleepWalkerMeanness
    GMSleepWalker.meanness = GM.Options.sleepWalkerMeanness
    table.insert(GM.nightmares, GMSleepWalker)
  end
  
  for i = 1, #GM.nightmares do
    local nightmare = GM.nightmares[i]
    nightmare.debug = GM.debug
    if nightmare.init then
      nightmare.init()
    end
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
  GMUtils.debug = GM.debug
  GMSanity.debug = GM.debug
  GMUtils.reweight(GM.forSleepSpawn)  
  for i = 0, GM.daysRunning - 1, 1 do
    GM.doDaily()
  end
end
Events.OnGameStart.Add(GM.init)

function doSquareScan(x, y, z)
  local square = getCell():getGridSquare(x, y, z)
  for i = 1, #GM.forScan do
    local nightmare = GM.forScan[i]
    if nightmare.addFromSquare then
      nightmare.addFromSquare(square)
    else
      if GM.debug then print("GM Warn: Nightmare at GM.forScan[" .. i .."] do not have an addFromSquare method") end
    end
  end
end

-- Scan a block of square around the player evertime they move
function GM.playerMove(player)
  local distance = GM.scanRadius
  
  local y = player:getY() - distance
  for x = player:getX() - distance, player:getX() + distance do
    doSquareScan(x, y, player:getZ())
  end    
  y = player:getY() + distance
  for x = player:getX() - distance, player:getX() + distance do
    doSquareScan(x, y, player:getZ())
  end
  
  local x = player:getX() - distance
  for y = player:getY() - distance + 1, player:getY() + distance - 1 do
    doSquareScan(x, y, player:getZ())
  end
  x = player:getX() + distance
  for y = player:getY() - distance + 1, player:getY() + distance - 1 do
    doSquareScan(x, y, player:getZ())
  end
end
Events.OnPlayerMove.Add(GM.playerMove)

function GM.onSeeNewRoom(room)
  for i = 1, #GM.forOnSeeNewRoom do
    local nightmare = GM.forOnSeeNewRoom[i]
    if nightmare.onSeeNewRoom then
      nightmare.onSeeNewRoom(room)
    else
      if GM.debug then print("GM Warn: Nightmare at GM.forScan[" .. i .."] do not have an onSeeNewRoom method") end
    end
  end 
end
Events.OnSeeNewRoom.Add(GM.onSeeNewRoom)

function GM.update(player)
  for i = 1, #GM.forUpdate do
    local nightmare = GM.forUpdate[i]
    if nightmare.update then
      nightmare.update(player)
    else
      if GM.debug then print("GM Warn: Nightmare at GM.forScan[" .. i .."] do not have an update method") end
    end
  end 
end
Events.OnPlayerUpdate.Add(GM.update)

function GM.sleepNightmareGenerator(player)
  --Stop current wake nightmare, if there is one
  local nightmare = GMUtils.weightedRandom(GM.forSleepSpawn)
  if GM.debug then print("GM Sleep nightmare to be spawned: ", nightmare.name) end
  if nightmare.spawn then
    local sound = nil
    if nightmare.getSound then
      sound = nightmare.getSound()
    end
    if not sound then
      sound = "GMMommy"
    end
    GM.nightmareSound = getSoundManager():PlayWorldSound(sound, false, player:getCurrentSquare(), 0.2, 60, 0.5, false)  
    GM.sleepNightmare = nightmare.spawn(player)
  else
    if GM.debug then print("GM Warn: Nightmare at GM.forScan[" .. i .."] do not have a spawn method") end
  end
end  

function GM.EveryTenMinutes()
  local player = getPlayer()
	local is_asleep = player:isAsleep()
  -- Asleep nightmares
	if is_asleep then
    -- finish off awake nightmare
    if GM.busyWithWakeNightmare then
      GM.busyWithWakeNightmare = false
      if GM.wakeNightmare and GM.wakeNightmare.unspawn then
        GM.wakeNightmare.unspawn(player)
        GM.wakeNightmare = nil
      end
      if GM.nightmareSound then
        GM.nightmareSound:stop()
        GM.nightmareSound = nil
      end
    end
    -- Do one nightmare per sleep cycle
    if not GM.busyWithSleepNightmare then
      if GM.debug then print('GM Do new sleep nightmare spawn here') end
      GM.busyWithSleepNightmare = true
      if GM.nightmareSound then
        GM.nightmareSound:stop()
        GM.nightmareSound = nil
      end
      if GM.debug then print("GM getForcedWakeUpTime = ", player:getForceWakeUpTime()) end
      GM.sleepNightmareGenerator(player)
    end
  else
    -- Awake nightmares
    -- finish off sleep nightmare
    if GM.busyWithSleepNightmare then
      GM.busyWithSleepNightmare = false
      if GM.sleepNightmare and GM.sleepNightmare.unspawn then
        GM.sleepNightmare.unspawn(player)
        GM.sleepNightmare = nil
      end
      if GM.nightmareSound then
        GM.nightmareSound:stop()
        GM.nightmareSound = nil
      end
    end
    
  end
end
Events.EveryTenMinutes.Add(GM.EveryTenMinutes)

function GM.doDaily()
  for i = 1, #GM.nightmares do
    local nightmare = GM.nightmares[i]
    if nightmare.daily then
      nightmare.daily(GM.Options.insanityFactor)
    end
  end
  GMUtils.reweight(GM.forSleepSpawn)
end

function GM.EveryDays()
  GM.doDaily()
  GM.daysRunning = GM.daysRunning + 1
end
Events.EveryDays.Add(EveryDays)
