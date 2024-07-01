-- ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐                                                                                                     
-- │ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
-- │    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
-- │   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
-- │  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
-- │ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ © Copyright 2024                                                                                   │ 
-- └────────────────────────────────────────────────────────────────────────────────────────────────────┘


-- TODO LIST
-- TV Sprite update
-- Samara's hair and dress, no shoes
-- Radio sound

GMTV = {}
GMTV.debug = false
GMTV.name = "Devices"
GMTV.needScan = true
GMTV.needOnSeeNewRoom = true
GMTV.needUpdate = true
GMTV.needSleepSpawn = false
GMTV.spawnWeight = 10 -- Not used, just in case
GMTV.meanness = 0 -- Not used, just in case
GMTV.initMeanness = 0

GMTV.sound = nil
GMTV.tvList = {}
GMTV.radioList = {}
GMTV.scanning = false

GMTV.update = function(player)
  if GMTV.scanning then 
    if GMTV.debug then print("GM TV: Still scanning") end
    return
  end
  --if GMTV.debug then print("GM TV: GMTV.tvList: ", GMTV.tvList) end
  for i = 1, #GMTV.tvList do
    local tv = GMTV.tvList[i]
    if tv:getCell() == player:getCell() then
      local sprite = tv:getSprite()
      local spriteName = sprite:getName()
      if GMTV.debug then print("GM TV: Sprite name: ", spriteName) end
      if tv:isFacing(player) and tv:getModData() and tv:getModData().GMTV then      
        --Just for testing
        local deviceData = tv:getDeviceData()
        --if GMTV.debug then print("GM TV: deviceData: canBePoweredHere: ", deviceData:canBePoweredHere()) end
        --if GMTV.debug then print("GM TV: deviceData: getIsTelevision:  ", deviceData:getIsTelevision()) end
        --if GMTV.debug then print("GM TV: deviceData: getIsTurnedOn:    ", deviceData:getIsTurnedOn()) end   
        --if GMTV.debug then print("GM TV: deviceData: getPower:         ", tostring(deviceData:getPower())) end
        if not tv:getModData().GMTV.spawned then  
          local x, y, z = tv:getSquare():getX(), tv:getSquare():getY(), tv:getSquare():getZ()
          GMTV.spawnSamara(x, y, z)
          tv:getModData().GMTV.spawned = true
          --change stats
          GMSanity.updateStats(player, GMNightNoises.meanness, 10)
        end
      end
    end
  end
  for i = 1, #GMTV.radioList do
    local radio = GMTV.radioList[i]
    if radio:getCell() == player:getCell() then
      if not radio:getModData().GMTV.spawned and radio:HasPlayerInRange() then
        tv:getModData().GMTV.spawned = true
        GMTV.sound = getSoundManager():PlayWorldSound("GMMommyRadio", false, square, 0.2, 60, 0.5, false);
        --change stats
        GMSanity.updateStats(player, GMNightNoises.meanness, 10)
      end    
    end
  end  
end

function GMTV.AddToList(object, tv)
  if tv then
    for i = 1, #GMTV.tvList do
      if GMTV.tvList[i] == object then return end -- don't add duplicates
    end
    table.insert(GMTV.tvList, object)    
    if GMTV.debug then print("GM TV: adding tv to list") end
  else
    for i = 1, #GMTV.radioList do
      if GMTV.radioList[i] == object then return end -- don't add duplicates
    end
    table.insert(GMTV.radioList, object)    
    if GMTV.debug then print("GM TV: adding radio to list") end
  end  
end

function GMTV.spawnSamara(x, y, z)
  local pattern = "^Base.Dress"
  local zombies = addZombiesInOutfit(x, y, z, 1, "Classy", 100)
  if zombies then
    local samara = zombies:get(0)--createZombie(x, y, z, nil, 0, IsoDirections.N)
    samara:setDir(getDirectionToPlayer(samara, getPlayer()))
    samara:setCrawlerType(3)
    samara:setCrawler(true)
    samara:setBecomeCrawler(true)
    samara:setCanWalk(false)
    --if GMTV.debug then print("GM TV: getRealState()", samara:getRealState()) end
    local humanVisual = samara:getHumanVisual()
    if humanVisual then
      if GMTV.debug then print("GM TV: HumanVisual") end   
      --Hair
      humanVisual:setHairColor(ImmutableColor.black)
      humanVisual:setHairModel("Long2")
      --Skin
      humanVisual:setSkinColor(ImmutableColor.white)
      
      humanVisual:removeBlood()
      
      humanVisual:removeDirt()
      humanVisual:setDirt(BloodBodyPartType.Foot_L, 1.0)
      humanVisual:setDirt(BloodBodyPartType.Foot_R, 1.0)
      humanVisual:setDirt(BloodBodyPartType.ForeArm_L, 1.0)
      humanVisual:setDirt(BloodBodyPartType.ForeArm_R, 1.0)
      humanVisual:setDirt(BloodBodyPartType.Hand_L, 1.0)
      humanVisual:setDirt(BloodBodyPartType.Hand_R, 1.0)
      humanVisual:setDirt(BloodBodyPartType.Neck, 1.0)
      humanVisual:setDirt(BloodBodyPartType.LowerLeg_L, 1.0)
      humanVisual:setDirt(BloodBodyPartType.LowerLeg_L, 1.0)
      humanVisual:setDirt(BloodBodyPartType.LowerLeg_R, 1.0)
      --Bandages, etc
      local itemVisuals = humanVisual:getBodyVisuals()
      if itemVisuals then
        if GMTV.debug then print("GM TV: HV ItemVisuals ", itemVisuals:size()) end
        itemVisuals:clear()
      end
    end
    local dressItem = nil
    local itemVisuals = samara:getItemVisuals()
    if itemVisuals then
      if GMTV.debug then print("GM TV: ItemVisuals ", itemVisuals:size()) end
      local size = itemVisuals:size()
      for i = size - 1, 0, -1 do
        local itemVisual = itemVisuals:get(i)        
        if GMTV.debug then print("GM TV: ItemType ", itemVisual:getItemType()) end
        if string.find(itemVisual:getItemType(), pattern) then
          dressItem = itemVisual
          if GMTV.debug then print("GM TV: Grabbing ", itemVisual:getItemType()) end
          break        
        end
      end
      if dressItem then 
        itemVisuals:clear()    
        dressItem:setHue(0.00)
        dressItem:setTint(ImmutableColor.white)
            
        dressItem:removeBlood()
        dressItem:removeDirt()
        dressItem:setDirt(BloodBodyPartType.UpperArm_L, 1.0)
        dressItem:setDirt(BloodBodyPartType.UpperArm_R, 1.0)
        dressItem:setDirt(BloodBodyPartType.ForeArm_L, 1.0)
        dressItem:setDirt(BloodBodyPartType.ForeArm_R, 1.0)
        dressItem:setDirt(BloodBodyPartType.Torso_Lower, 1.0)
        dressItem:setDirt(BloodBodyPartType.Neck, 1.0)
        dressItem:setDirt(BloodBodyPartType.UpperLeg_L, 1.0)
        dressItem:setDirt(BloodBodyPartType.UpperLeg_L, 1.0)
        itemVisuals:add(dressItem)
      end
    end
    
    --samara:addToWorld()
  end
end

function GMTV.doTVStuff(square, tv)
  local isoSprite = tv:getSprite()
  local spriteName = isoSprite:getName()
  if GMTV.debug then print("GM TV: sprite name ", spriteName) end
  -- store player in tv moddata until isFacing(IsoPlayer player)
  local md = tv:getModData()
  if not md.GMTV then
    md.GMTV = {}
    md.GMTV.spawned = false
    md.GMTV.square = square
  end
  GMTV.AddToList(tv, "tv")
end

function GMTV.doRadioStuff(square, radio)
  if GMTV.debug then print("GM TV: Do radio stuff") end         
  local md = radio:getModData()
  if not md.GMTV then
    md.GMTV = {}
    md.GMTV.spawned = false
    md.GMTV.square = square
  end
  GMTV.AddToList(radio, "radio")
end

GMTV.addFromSquare = function(square)
  GMTV.scanFor(square, false)
end

function GMTV.scanFor(square, firstScan)  
  if not getPlayer():isInARoom() then return end
  if not square then return end--handles teleport
  GMTV.scanning = true
  local objects = square:getObjects()
  local wSize = objects:size()
  if GMTV.debug then print("GM TV: Number of objects on square ", wSize) end
  for k = 0, wSize - 1, 1 do
    local object = objects:get(k)
    if object:getObjectName() == "Television" then
      if firstScan then
        GMTV.doTVStuff(square, object)
      else
        if object:hasModData() then
          local md = object:getModData()
          if md.GMTV then
            GMTV.AddToList(object, "tv")
          end
        end
      end
    elseif object:getObjectName() == "Radio" then
      if firstScan then
        GMTV.doRadioStuff(square, object)
      else
        if object:hasModData() then
          local md = object:getModData()
          if md.GMTV then
            GMTV.AddToList(object, "radio")
          end
        end
      end      
    end  
  end
  GMTV.scanning = false
end

GMTV.onSeeNewRoom = function(isoRoom)
  if isoRoom then
    if GMTV.debug then print("GM TV: room ", isoRoom:getName()) end
    local squares = isoRoom:getSquares()
    local sqSize = squares:size()
    if GMTV.debug then print("GM TV: Number of squares in room ", sqSize) end
    for j = 0, sqSize - 1 do
      local square = squares:get(j)
      --Objects
      GMTV.scanFor(square, true)      
    end        
  else
    if GMTV.debug then print("GM Doors: isoRoom is nil") end
  end  
end

function GMTV.daily(insanityFactor)
  local factor = 0.5/5
  GMTV.meanness = GMUtils.changeMeanness(insanityFactor, GMTV.initMeanness, GMTV.meanness, factor)
end
