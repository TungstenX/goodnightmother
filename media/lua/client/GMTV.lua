-- TODO LIST
-- TV Sprite update
-- Samara's hair and dress, no shoes
-- Radio sound

GMTV = {}
GMTV.debug = false
GMTV.needScan = true
GMTV.needOnSeeNewRoom = true
GMTV.needUpdate = true
GMTV.needSleepSpawn = false
GMTV.spawnWeight = 10 -- not used

GMTV.sound = nil
GMTV.tvList = {}

-- Do nothing
GMTV.init = function()
end

GMTV.update = function(player)
  for i = 1, #GMTV.tvList do
    local tv = GMTV.tvList[i]
    if tv:isFacing(player) then
      local x, y, z = tv:getSquare():getX(), tv:getSquare():getY(), tv:getSquare():getZ()
      GMTV.spawnSamara(x, y, z)
      tv.spawned = true
    end
  end
end

function GMTV.AddToList(object)
  for i = 1, #GMTV.tvList do
    if GMTV.tvList[i] == object then return end -- don't add duplicates
  end
  table.insert(GMTV.tvList, object)    
  if GMTV.debug then print("GM TV: adding tv to list") end
end

function GMTV.spawnSamara(x, y, z)
  local zombie = createZombie(x, y, z, nil, 0, IsoDirections.S)
  zombie:setFemaleEtc(true)
  zombie:dressInNamedOutfit("Classy")
  zombie:DoZombieInventory()
  zombie:setCrawlerType(1)
  zombie:addToWorld()
end

function GMTV.doTVStuff(square, tv)
  local isoSprite = tv:getSprite()
  local spriteName = isoSprite:getName()
  if GMTV.debug then print("GM TV: sprite name ", spriteName) end
  -- store player in tv moddata until isFacing(IsoPlayer player)
  local md = tv:getModData()
  md.GMTV = {}
  md.GMTV.spawned = false
  md.GMTV.square = square
  GMTV.AddToList(tv)
end

function GMTV.doRadioStuff(square)
  if GMTV.debug then print("GM TV: Do radio stuff") end
  if GMTV.sound then
    GMTV.sound:stop();
    GMTV.sound = nil
  end          
  GMTV.sound = getSoundManager():PlayWorldSound("GMMommyRadio", false, square, 0.2, 60, 0.5, false);
end

GMTV.addFromSquare = function(square)
  GMTV.scanFor(square, false)
end

function GMTV.scanFor(square, firstScan)  
  if not square then return end--handles teleport
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
            GMTV.AddToList(object)
          end
        end
      end
    elseif object:getObjectName() == "Radio" and firstScan then
      GMTV.doRadioStuff(square)
    else 
      if GMTV.debug then print("GM TV: Not TV or Radio ", object:getObjectName()) end
    end  
  end
end

GMTV.forOnSeeNewRoom = function(isoRoom)
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