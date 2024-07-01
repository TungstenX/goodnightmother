-- ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐                                                                                                     
-- │ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
-- │    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
-- │   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
-- │  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
-- │ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ © Copyright 2024                                                                                   │ 
-- └────────────────────────────────────────────────────────────────────────────────────────────────────┘
-- TODO: Add moddata to count zombies. When all have been dispense, then "normal" stepvan
require "Vehicles/Vehicles"

GMVehicles = GMVehicles or {}
GMVehicles.LOG = GMVehicles.LOG or {}
GMVehicles.LOG.debug = getCore():getDebug() or false
GMVehicles.LOG.trace = false

local OriginalVehiclesUseDoor = Vehicles.Use.Door
local OriginalVehiclesUseEngineDoor = Vehicles.Use.EngineDoor
local OriginalVehiclesUseTrunkDoor = Vehicles.Use.TrunkDoor

function Vehicles.Use.Door(vehicle, part, character)
  if vehicle:getScriptName() == "Base.StepVan_GM" then
    if GMVehicles.LOG.debug then print("No use door on possessed vehicles") end
    GMVehicles.spawnIceCreamZombies(vehicle, part)
  else
    OriginalVehiclesUseDoor(vehicle, part, character)
  end
end

function Vehicles.Use.EngineDoor(vehicle, part, character)
  if vehicle:getScriptName() == "Base.StepVan_GM" then
    if GMVehicles.LOG.debug then print("No use bonnet on possessed vehicles") end
    GMVehicles.spawnIceCreamZombies(vehicle, part)
  else
    OriginalVehiclesUseEngineDoor(vehicle, part, character)
  end	
end

function Vehicles.Use.TrunkDoor(vehicle, part, character)
  if vehicle:getScriptName() == "Base.StepVan_GM" then
    if GMVehicles.LOG.debug then print("No use boot on possessed vehicles") end
    GMVehicles.spawnIceCreamZombies(vehicle, part)
  else
    OriginalVehiclesUseTrunkDoor(vehicle, part, character)
  end
end

function GMVehicles.prepIceCreamZombies(zombies)
  if zombies then
    for i = 0, zombies:size() - 1 do
      local icz = zombies:get(i)
      local spoon = InventoryItemFactory.CreateItem("Base.Spoon")
      icz:setAttachedItem("Knife in Back", spoon)
      local icecream = InventoryItemFactory.CreateItem("Base.IcecreamMelted")    
      icecream:setRotten(true)
      icz:addItemToSpawnAtDeath(icecream)
      icz:resetModelNextFrame()
    end    
  end
end

function GMVehicles.spawnIceCreamZombies(vehicle, part)
  if GMVehicles.LOG.trace then print("\nVehicle dir: ".. tostring(vehicle:getDir()) .. "\nVehicle x:   " .. tostring(vehicle:getX()) .. "\nVehicle y:   ", tostring(vehicle:getY()) .. "\nPart id:     " .. tostring(part:getId())) end
    
  local x, y, z = vehicle:getX(), vehicle:getY(), vehicle:getZ()
  local xt1, xt2, yt1, yt2, xd, yd, xp, yp = x, x, y, y, x, y, x, y
  if vehicle:getDir() == IsoDirections.N then
    xt1, yt1, xt2, yt2, xd, yd, xp, yp = x - 1, y - 4, x, y - 3, x + 1, y + 1, x - 2, y + 1
  elseif vehicle:getDir() == IsoDirections.S then
    xt1, yt1, xt2, yt2, xd, yd, xp, yp = x - 1, y + 4, x, y + 3, x + 1, y - 1, x - 2, y - 1
  elseif vehicle:getDir() == IsoDirections.E then
    xt1, yt1, xt2, yt2, xd, yd, xp, yp = x + 4, y - 1, x + 3, y, x - 1, y + 1, x + 1, y + 2
  elseif vehicle:getDir() == IsoDirections.W then
    xt1, yt1, xt2, yt2, xd, yd, xp, yp = x - 4, y - 1, x - 3, y, x + 1, y + 1, x + 1, y - 2
  end
  
  if part:getId() ~= "DoorRear" then
    if GMVehicles.LOG.trace then print("Trunk door") end
    GMVehicles.prepIceCreamZombies(addZombiesInOutfitArea(xt1, yt1, xt2, yt2, z, 8, "Cook_IceCream", 50))--trunk
  end
  if part:getId() ~= "DoorFrontLeft" then
    if GMVehicles.LOG.trace then print("Driver door") end
    GMVehicles.prepIceCreamZombies(addZombiesInOutfit(xd, yd, z, 1, "Cook_IceCream", 50))--driver
  end
  if part:getId() ~= "DoorFrontRight" then
    if GMVehicles.LOG.trace then print("Passenger door") end
    GMVehicles.prepIceCreamZombies(addZombiesInOutfit(xp, yp, z, 1, "Cook_IceCream", 50))--passenger
  end
end