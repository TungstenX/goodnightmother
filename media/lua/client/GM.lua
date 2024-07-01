--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
└────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐
│ Goodnight Mother │
└──────────────────┘

- Sleep Meanness (0-9)  0 = annoying, 9 = "Really!?! WTF!"
- GMNightNoises  = 0 - Do nothing, just play eerie sounds when a player while a player is asleep 
- GMCorpse       = 1 - Place a corps near a player when sleeping
- GMDoors        = 5 - Open all closed doors and windows, Close all open doors and windows
- GMLights       = 9 - Freaky lights, always 
- GMNaked        = 2 - Force unequipe and drop all inventory items on the floor when a player sleeps
- GMPoltergeists = 1 - When a player sleeps; move furniture around in the building
-                = 2 - When a player sleeps; Shuffle all items in all containers in a building
-                = 9 - When a player sleeps; Unpack all items from all containers in a building
- GMSleepWalker  = 2 - Teleport a player to another room when they sleep, same building

- Wake Meanness (0-9)  0 = annoying, 9 = "Really!?! WTF!"
- GMDayNoises    = 0 - Do nothing, just play eerie sounds when a player is moving in different areas
- GMTV           = 1 - Play radio sounds (once per device) when a player enter a room with a radio
-                = 1 - Play phone ring sounds (once per device) when a player enter a room with a ???
-                = 1 - Play doorbell ring sounds (once per device) when a player enter a room with a ???
-                = 9 - Spawn Samara when player face TV (once per device)

Meannes translated to spawnWeight
]]

-- Require not really needed, just to keep track
require "GMUtils"
require "GMCorpse"
require "GMDoors"
require "GMLights"
require "GMNaked"
require "GMNightNoises"
require "GMScarecrow" 
require "GMSleepWalker"
require "GMPoltergeists"
require "GMPuppetMaster"
require "GMTV"

GM = GM or {}
GM.LOG = GM.LOG or {}
GM.LOG.debug = getCore():getDebug() or false
GM.LOG.trace = false

GM.nightmares = {}
GM.forScan = {}
GM.forOnSeeNewRoom = {}
GM.forUpdate = {}
GM.forSleepSpawn = {}
GM.SCAN_RADIUS = 2 -- How many squares? ((scanRadius * 2) + 1)^2
GM.busyWithSleepNightmare = false
GM.busyWithWakeNightmare = false
GM.nightmareSound = nil
GM.sleepNightmare = nil
GM.wakeNightmare = nil
GM.daysRunning = 0

local makeKeyName(name, postFix)
  return string.lower(string.sub(name, 1, 1)) .. string.sub(name, 2) .. postFix
end

-- Initialise function lists 
--  Called by OnGameStart
function GM.init()  
  local availableNightmares = {GMCorpse, GMTV, GMNaked, GMDoors, GMLights, GMNaked, GMNightNoises, GMScarecrow, GMSleepWalker, GMPoltergeists, GMPuppetMaster}
  
  GM.nightmares = {} --resetting
  for i = 1, #availableNightmares do
    local name = availableNightmares[i]["name"]
    local enableKey = makeKeyName(name, "Enabled")
    local meannessKey = makeKeyName(name, "Meanness")
    if GM.Options[enableKey] and GM.nightmares[name] == nil then
      if GM.LOG.debug then print("init adding: ", name) end
      availableNightmares[i]["initMeanness"] = GM.Options[meannessKey]
      availableNightmares[i]["meanness"] = GM.Options[meannessKey]
      GM.nightmares[name] = availableNightmares[i]
    elseif not GM.Options[enableKey] and GM.nightmares[name] ~= nil then
      GM.removeNightmare(name)
    end
  end
  
  for i = 1, #GM.nightmares do
    local nightmare = GM.nightmares[i]
    if nightmare.LOG then
      nightmare.LOG = GM.LOG -- Think about this
    end
    if nightmare.init then
      if GM.LOG.debug then print("init - init: ", nightmare.name) end
      nightmare.init()
    end
    if nightmare.needScan and GM.forScan[nightmare.name] == nil then      
      if GM.LOG.debug then print("init adding to forScan: ", nightmare.name) end
      GM.forScan[nightmare.name] =  nightmare
    end
    if nightmare.needOnSeeNewRoom and GM.forOnSeeNewRoom[nightmare.name] == nil then
      if GM.LOG.debug then print("init adding to needOnSeeNewRoom: ", nightmare.name) end
      GM.forOnSeeNewRoom[nightmare.name] =  nightmare
    end
    if nightmare.needUpdate and GM.forUpdate[nightmare.name] == nil then
      if GM.LOG.debug then print("init adding to needUpdate: ", nightmare.name) end
      GM.forUpdate[nightmare.name] =  nightmare
    end
    if nightmare.needSleepSpawn and GM.forSleepSpawn[nightmare.name] == nil then
      if GM.LOG.debug then print("init adding to needSleepSpawn: ", nightmare.name) end
      GM.forSleepSpawn[nightmare.name] =  {nightmare.spawnWeight, nightmare}--???
    end
  end
  GMUtils.debug = GM.LOG.debug
  GMSanity.debug = GM.LOG.debug
  GMUtils.reweight(GM.forSleepSpawn)  
  for _ = 0, GM.daysRunning - 1 do
    GM.doDaily()
  end
end
Events.OnGameStart.Add(GM.init)

function GM.removeNightmare(name)
  if GM.nightmares[name] ~= nil then
    if GM.LOG.debug then print("init removing: ", name) end
    GM.nightmares[name] = nil
  end
  if GM.forScan[name] ~= nil then      
      if GM.LOG.debug then print("init removing from forScan: ", name) end
      GM.forScan[name] = nil
  end
  if GM.forOnSeeNewRoom[name] ~= nil then
    if GM.LOG.debug then print("init removing from needOnSeeNewRoom: ", name) end
    GM.forOnSeeNewRoom[name] = nil
  end
  if GM.forUpdate[name] ~= nil then
    if GM.debdebugugFine then print("init removing from needUpdate: ", name) end
    GM.forUpdate[name] = nil
  end
  if GM.forSleepSpawn[name] ~= nil then
    if GM.LOG.debug then print("init removing from needSleepSpawn: ", name) end
    GM.forSleepSpawn[name] = nil
  end
end

function GM.doSquareScan(x, y, z)
  local square = getCell():getGridSquare(x, y, z)
  for name, nightmare in pairs(GM.forScan) do
    if nightmare.addFromSquare then
      nightmare.addFromSquare(square)
    else
      if GM.LOG.debug then print("GM Warn: Nightmare at GM.forScan[" .. name .. "] do not have an addFromSquare method") end
    end
  end
end

-- TODO: Change to read radius from nightmare? Or Nightmare must override own behaviour? 
-- Scan a block of square around the player evertime they move
function GM.playerMove(player)
  local distance = GM.SCAN_RADIUS
  
  local y = player:getY() - distance
  for x = player:getX() - distance, player:getX() + distance do
    GM.doSquareScan(x, y, player:getZ())
  end    
  y = player:getY() + distance
  for x = player:getX() - distance, player:getX() + distance do
    GM.doSquareScan(x, y, player:getZ())
  end
  
  local x = player:getX() - distance
  for y = player:getY() - distance + 1, player:getY() + distance - 1 do
    GM.doSquareScan(x, y, player:getZ())
  end
  x = player:getX() + distance
  for y = player:getY() - distance + 1, player:getY() + distance - 1 do
    GM.doSquareScan(x, y, player:getZ())
  end
end
Events.OnPlayerMove.Add(GM.playerMove)

function GM.onSeeNewRoom(room)
  for name, nightmare in pairs(GM.forOnSeeNewRoom) do
    if nightmare.onSeeNewRoom then
      nightmare.onSeeNewRoom(room)
    else
      if GM.LOG.debug then print("GM Warn: Nightmare at GM.forScan[" .. name .. "] do not have an onSeeNewRoom method") end
    end
  end 
end
Events.OnSeeNewRoom.Add(GM.onSeeNewRoom)

function GM.update(player)
  local md = player:getModData()
  if md and md.lightAngle then
    md.lightAngle = md.lightAngle + 0.02
  end
  
  for name, nightmare in pairs(GM.forUpdate) do
    if nightmare.update then
      nightmare.update(player)
    else
      if GM.LOG.debug then print("GM Warn: Nightmare at GM.forScan[" .. name .. "] do not have an update method") end
    end
  end
end
Events.OnPlayerUpdate.Add(GM.update)

function GM.sleepNightmareGenerator(player)
  --Stop current wake nightmare, if there is one
  local nightmare = GMUtils.weightedRandom(GM.forSleepSpawn)
  if GM.LOG.debug then print("GM Sleep nightmare to be spawned: ", nightmare.name) end
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
    if GM.LOG.debug then print("GM Warn: Nightmare at GM.forScan[" .. nightmare.name .. "] do not have a spawn method") end
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
      if GM.LOG.debug then print('GM Do new sleep nightmare spawn here') end
      GM.busyWithSleepNightmare = true
      if GM.nightmareSound then
        GM.nightmareSound:stop()
        GM.nightmareSound = nil
      end
      if GM.LOG.debug then print("GM getForcedWakeUpTime = ", player:getForceWakeUpTime()) end
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
  for _, nightmare in pairs(GM.nightmares) do
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
