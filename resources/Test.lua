


--===========================================DELETE====================


function printObject(object)
  
  print("\tObject")
  if not object then
    print("\t\tNo Object")
    return
  end
  object:debugPrintout()
  print("\t\tName:                       ", tostring(object:getName()))
  print("\t\tObject Index:               ", tostring(object:getObjectIndex()))
  print("\t\tObject Name:                ", tostring(object:getObjectName()))  
  print("\t\tcanAddSheetRope:            ", tostring(object:canAddSheetRope()))
  print("\t\tgetDamage:                  ", tostring(object:getDamage()))
  print("\t\tgetDir:                     ", tostring(object:getDir()))
  print("\t\tgetIsSurfaceNormalOffset:   ", tostring(object:getIsSurfaceNormalOffset()))
  print("\t\tgetMovingObjectIndex:       ", tostring(object:getMovingObjectIndex()))
  print("\t\tgetOffsetX:                 ", tostring(object:getOffsetX()))
  print("\t\tgetOffsetY:                 ", tostring(object:getOffsetY()))
  print("\t\tgetOutlineHighlightCol:     ", tostring(object:getOutlineHighlightCol()))
  print("\t\tgetOverlaySprite:           ", tostring(object:getOverlaySprite()))

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
  
  print("\t\tScript Name:                ", tostring(object:getScriptName()))
  print("\t\tSpecial Object Index:       ", tostring(object:getSpecialObjectIndex()))
  local sprite = object:getSprite()
  if sprite then
    print("\t\tSprite Name:              ", tostring(object:getSprite():getName()))
  end  
  local childSprites = object:getChildSprites()
  if childSprites then
    print("\t\tChild Sprites:")
    for i = 0, childSprites:size() - 1, 1 do
      local childSprite = childSprites:get(i)
      print("\t\t\tSprite Name: ", tostring(childSprite:getName()))
    end
  end
  
  print("\t\tgetStaticMovingObjectIndex: ", tostring(object:getStaticMovingObjectIndex()))
  print("\t\tgetTextureName:             ", tostring(object:getTextureName()))
  print("\t\tgetThumpCondition:          ", tostring(object:getThumpCondition()))
  print("\t\tgetTile:                    ", tostring(object:getTile()))
  print("\t\tType:                       ", tostring(object:getType()))
  print("\t\tWorld Object Index:         ", tostring(object:getWorldObjectIndex()))
  print("\t\thasModData:                 ", tostring(object:hasModData()))
  print("\t\tis Exist In The World:      ", tostring(object:isExistInTheWorld()))
  print("\t\tisFloor:                    ", tostring(object:isFloor()))
  
end

function Test4MenuEntry()
  local player = getPlayer()
  local md = player:getModData()
  if not md then
    print("No player md!")
    return
  end
  if not md.lightAngle then
    md.lightAngle = 0.0    
  end    
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
function Test2MenuEntry()  
  print("GM test 2 start")
  local vehicleName = "StepVan_GM"
  --[[local scripts = getScriptManager():getAllVehicleScripts()
  for i = 0, scripts:size() - 1 do
    local script = scripts:get(i)
    print("GM test 2: Scriptm full name", script:getFullName())
  end
  local vehicle = BaseVehicle.new(getCell())
  if vehicle then
    local player = getPlayer()
    vehicle:setScriptName("Base.StepVan_GM")
    vehicle:setX(player:getX() + 6)
    vehicle:setY(player:getY() + 6)
    vehicle:setZ(0.0F)
    local square = getSquare(vehicle:getX(), vehicle:getY(), vehicle:getZ())
    vehicle:setSquare(square)
    --vehicle:getSquare():getChunk().vehicles:add(vehicle) --??
    -- ?? vehicle.chunk = vehicle.square.chunk;
    vehicle:addToWorld()
    -- ?? VehiclesDB2.instance.addVehicle(vehicle)
  else
    print("Ah nuts!")
  end]]
  --[[ WorldSimulation.instance.create();
                BaseVehicle var2 = new BaseVehicle(IsoWorld.instance.CurrentCell);
                if (StringUtils.isNullOrWhitespace(var0)) {
                    VehicleScript var3 = (VehicleScript)PZArrayUtil.pickRandom(var1);
                    var0 = var3.getFullName();
                }

                var2.setScriptName(var0);
                var2.setX(IsoPlayer.getInstance().getX());
                var2.setY(IsoPlayer.getInstance().getY());
                var2.setZ(0.0F);
                if (IsoChunk.doSpawnedVehiclesInInvalidPosition(var2)) {
                    var2.setSquare(IsoPlayer.getInstance().getSquare());
                    var2.square.chunk.vehicles.add(var2);
                    var2.chunk = var2.square.chunk;
                    var2.addToWorld();
                    VehiclesDB2.instance.addVehicle(var2);
                }
  ]]
  if isClient() then
    print("GM test 2 is Client")
		local command = string.format("/addvehicle %s", tostring(vehicleName))
		SendCommandToServer(command)
	else
    print("GM test 2 is not Client")
		addVehicle(tostring(vehicleName))
	end
 -- local player = getPlayer()
 -- player:setZ(1.0)
  print("GM test 2 end")
end


function Test1MenuEntry(worldObjects)
  print("GM test 1 start")
  local player = getPlayer()
  player:setZ(0.0)
  --for k,v in pairs(worldObjects) do
  --  printObject(v)
    --print(k, tostring(v:getObjectName()))
    
    --print("getAngleX(): ", tostring(v:getAngleX()))
    
    --print("getAngleY(): ", tostring(v:getAngleY()))
    --print("getAngleZ(): ", tostring(v:getAngleZ()))
    --print("getAuthorizationDescription(): ", tostring(v:getAuthorizationDescription()))
    --print("getCurrentSpeedKmHour(): ", tostring(v:getCurrentSpeedKmHour()))
    --print("getCurrentSteering(): ", tostring(v:getCurrentSteering()))
    --print("getName(): ", tostring(v:getName()))
    --print("getObjectName(): ", tostring(v:getObjectName()))
    --print("getScript(): ", tostring(v:getScript()))
    --print("getScriptName(): ", tostring(v:getScriptName()))
    
    --print("isEngineRunning(): ", tostring(v:isEngineRunning()))
    --if not v:isEngineRunning() then
      --v:tryStartEngine()
    --end
    
  --end
  
  print("GM test 1 end")
end

local function testContextMenu(playerIndex, context, worldObjects, test)
	context:addOption("Test 1 - Vehicle props", worldObjects, Test1MenuEntry, worldObjects)
	context:addOption("Test 2 - Spawn vehicle", getSpecificPlayer(playerIndex), Test2MenuEntry)
	--context:addOption("Test 3 - Poltergeists Unpack", getSpecificPlayer(playerIndex), Test3MenuEntry)
	context:addOption("Test 4 - Scan player squares", getSpecificPlayer(playerIndex), Test4MenuEntry)
	--context:addOption("Test 5 - Change every 10", getSpecificPlayer(playerIndex), Test5MenuEntry)
end

Events.OnFillWorldObjectContextMenu.Add(testContextMenu)

local function OnUseVehicle(player, baseVehicle, pressedNotTapped)
  print("OnUseVehicle start")
  print("player: ", tostring(player))
  print("pressedNotTapped: ", tostring(pressedNotTapped))
  print("getAngleX(): ", tostring(baseVehicle:getAngleX()))
  print("getAngleY(): ", tostring(baseVehicle:getAngleY()))
  print("getAngleZ(): ", tostring(baseVehicle:getAngleZ()))
  print("getAuthorizationDescription(): ", tostring(baseVehicle:getAuthorizationDescription()))
  print("getCurrentSpeedKmHour(): ", tostring(baseVehicle:getCurrentSpeedKmHour()))
  print("getCurrentSteering(): ", tostring(baseVehicle:getCurrentSteering()))
  print("getName(): ", tostring(baseVehicle:getName()))
  print("getObjectName(): ", tostring(baseVehicle:getObjectName()))
  print("getScript(): ", tostring(baseVehicle:getScript()))
  print("getScriptName(): ", tostring(baseVehicle:getScriptName()))
  
  print("isEngineRunning(): ", tostring(baseVehicle:isEngineRunning()))
  if not baseVehicle:isEngineRunning() then
    baseVehicle:engineDoStarting()
  end   
  
  print("OnUseVehicle end")
end

local function OnEnterVehicle(character)
  print("OnEnterVehicle start")
  print("player: ", tostring(character))  
  print("OnEnterVehicle end")
end

LuaEventManager.AddEvent("OnUseVehicle")
--Events.OnEnterVehicle.Add(OnEnterVehicle)
Events.OnUseVehicle.Add(OnUseVehicle)






--[[
  if GM.Options.corpseEnabled and GM.nightmares[GMCorpse.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMCorpse.name) end
    GMCorpse.initMeanness = GM.Options.corpseMeanness
    GMCorpse.meanness = GM.Options.corpseMeanness
    GM.nightmares[GMCorpse.name] = GMCorpse
  elseif not GM.Options.corpseEnabled and GM.nightmares[GMCorpse.name] ~= nil then
    GM.removeNightmare(GMCorpse.name)
  end
  
  if GM.Options.devicesEnabled and GM.nightmares[GMTV.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMTV.name) end
    GMTV.initMeanness = GM.Options.devicesMeanness
    GMTV.meanness = GM.Options.devicesMeanness
    GM.nightmares[GMTV.name] = GMTV
  elseif not GM.Options.devicesEnabled and GM.nightmares[GMTV.name] ~= nil then
    GM.removeNightmare(GMTV.name)
  end
  
  if GM.Options.nakedEnabled and GM.nightmares[GMNaked.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMNaked.name) end
    GMNaked.initMeanness = GM.Options.nakedMeanness
    GMNaked.meanness = GM.Options.nakedMeanness
    GM.nightmares[GMNaked.name] = GMNaked
  elseif not GM.Options.nakedEnabled and GM.nightmares[GMNaked.name] ~= nil then
    GM.removeNightmare(GMNaked.name)
  end
  
  if GM.Options.nightNoisesEnabled and GM.nightmares[GMNightNoises.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMNightNoises.name) end
    GMNightNoises.initMeanness = GM.Options.nightNoisesMeanness
    GMNightNoises.meanness = GM.Options.nightNoisesMeanness
    GM.nightmares[GMNightNoises.name] = GMNightNoises
  elseif not GM.Options.nightNoisesEnabled and GM.nightmares[GMNightNoises.name] ~= nil then
    GM.removeNightmare(GMNightNoises.name)
  end
  
  if GM.Options.poltergeistsEnabled and GM.nightmares[GMPoltergeists.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMPoltergeists.name) end
    GMDoors.initMeanness = GM.Options.poltergeistsMeanness
    GMDoors.meanness = GM.Options.poltergeistsMeanness
    GMPoltergeists.initMeanness = GM.Options.poltergeistsMeanness
    GMPoltergeists.meanness = GM.Options.poltergeistsMeanness
    GM.nightmares[GMPoltergeists.name] = GMPoltergeists
    GM.nightmares[GMDoors.name] = GMDoors
  elseif not GM.Options.poltergeistsEnabled and GM.nightmares[GMPoltergeists.name] ~= nil then
    GM.removeNightmare(GMPoltergeists.name)
    GM.removeNightmare(GMDoors.name)
  end
  
  if GM.Options.scarecrowEnabled and GM.nightmares[GMScarecrow.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMScarecrow.name) end
    GMScarecrow.initMeanness = GM.Options.scarecrowMeanness
    GMScarecrow.meanness = GM.Options.scarecrowMeanness
    GM.nightmares[GMScarecrow.name] = GMScarecrow
  elseif not GM.Options.scarecrowEnabled and GM.nightmares[GMScarecrow.name] ~= nil then
    GM.removeNightmare(GMScarecrow.name)
  end
  
  if GM.Options.sleepWalkerEnabled and GM.nightmares[GMSleepWalker.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMSleepWalker.name) end
    GMSleepWalker.initMeanness = GM.Options.sleepWalkerMeanness
    GMSleepWalker.meanness = GM.Options.sleepWalkerMeanness
    GM.nightmares[GMSleepWalker.name] = GMSleepWalker
  elseif not GM.Options.sleepWalkerEnabled and GM.nightmares[GMSleepWalker.name] ~= nil then
    GM.removeNightmare(GMSleepWalker.name)
  end
  
  if GM.Options.lightsEnabled and GM.nightmares[GMLights.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMLights.name) end
    GMLights.initMeanness = GM.Options.lightsMeanness
    GMLights.meanness = GM.Options.lightsMeanness
    table.insert(GM.nightmares, GMLights)
    GM.nightmares[GMLights.name] = GMLights
  elseif not GM.Options.lightsEnabled and GM.nightmares[GMLights.name] ~= nil then
    GM.removeNightmare(GMLights.name)
  end
  
  if GM.Options.puppetMasterEnable and GM.nightmares[GMPuppetMaster.name] == nil then
    if GM.LOG.debug then print("init adding: ", GMPuppetMaster.name) end
    GMPuppetMaster.initMeanness = GM.Options.puppetMasterMeanness
    GMPuppetMaster.meanness = GM.Options.puppetMasterMeanness
    table.insert(GM.nightmares, GMPuppetMaster)
    GM.nightmares[GMPuppetMaster.name] = GMPuppetMaster
  elseif not GM.Options.puppetMasterEnable and GM.nightmares[GMPuppetMaster.name] ~= nil then
    GM.removeNightmare(GMPuppetMaster.name)
  end]]