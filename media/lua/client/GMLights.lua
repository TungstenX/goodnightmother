-- ┌────────────────────────────────────────────────────────────────────────────────────────────────────┐                                                                                                     
-- │ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
-- │    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
-- │   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
-- │  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
-- │ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
-- ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
-- │ © Copyright 2024                                                                                   │ 
-- └────────────────────────────────────────────────────────────────────────────────────────────────────┘

-- Copy and pasted code from PZ-Community-API as only some parts are being used

GMLights = GMLights or {}
GMLights.name = "Lights"
GMLights.debug = false
GMLights.needScan = false -- use own method
GMLights.needOnSeeNewRoom = false
GMLights.needUpdate = false --TODO
GMLights.needSleepSpawn = false
GMLights.spawnWeight = 10 -- TBD?
GMLights.meanness = 9 -- TODO, react on meannes
GMLights.initMeanness = 9

GMLights.SCAN_RADIUS = 5 -- streetlight radius / 4
GMLights.sources = GMLights.sources or {}
GMLights.START_RGB = 0.5
GMLights.SINE_WIDTH = 1.5
GMLights.PULSE_R_VALUE = 1.0
GMLights.pulseCount = 0
GMLights.busy = false

-- [FreakyLightObject]---------------------------------------------------------
require("ISBaseObject")

local FreakyLightObject = ISBaseObject:derive("FreakyLightObject")

function FreakyLightObject:update()
  local cell = getCell()
  if cell then
    local square = cell:getGridSquare(self.position.x, self.position.y, self.position.z)
    if square then
      if self.lightSource == nil then
        self.lightSource = IsoLightSource.new(self.position.x, self.position.y, self.position.z, 0.0, 0.0, 1.0, self.radius)
        cell:addLamppost(self.lightSource)
        IsoGridSquare.RecalcLightTime = -1
        if GMLights.debug then print("Light source ['" .. self.name .. "'] created at x: " .. self.position.x .." y: " .. self.position.y .. " z: " .. self.position.z) end
      end  
      self.lightSource:setRadius(self.radius)
      self.lightSource:setR(self.color.r)
      self.lightSource:setG(self.color.g)
      self.lightSource:setB(self.color.b)
    else
      self:destroy()
    end
  end
end

function FreakyLightObject:getX()
  return self.position.x
end

function FreakyLightObject:getY()
  return self.position.y
end

function FreakyLightObject:getZ()
  return self.position.z
end

function FreakyLightObject:destroy()
  if self.lightSource ~= nil then
    self.lightSource:setActive(false)
    getCell():removeLamppost(self.lightSource)
    self.lightSource = nil
    if GMLights.debug then print("Light source ['" .. self.name .. "'] destroyed at x: " .. self.position.x .. " y: " .. self.position.y .. " z: " ..self.position.z) end
  end
end

function FreakyLightObject:setRadius(radius)
  if type(radius) == "number" and radius > 0 then
    self.radius = radius
    self:update()
  end
end

function FreakyLightObject:GetColorOrDefault(color, defaultColor)
    if type(color) ~= "table" then
        return defaultColor
    end
    if type(color.r) ~= "number" then color.r = defaultColor.r; end
    if type(color.g) ~= "number" then color.g = defaultColor.g; end
    if type(color.b) ~= "number" then color.b = defaultColor.b; end
    if type(color.a) ~= "number" then color.a = defaultColor.a; end
    return color
end

function FreakyLightObject:setColor(color)
  if type(color) == "table" then
    self.color = FreakyLightObject:GetColorOrDefault(color, { r=1, g=1, b=1, a=1 })
    self:update()
  end
end

function FreakyLightObject:new(name, x ,y ,z, radius, color)
  local o = ISBaseObject:new()
  setmetatable(o, self)
  self.__index = self

  o.lightSource = nil

  o.name = name
  o.position = { x=x, y=y, z=z }
  o.radius = 1
  o.color = { r=1, g=1, b=1 }

  o:setRadius(radius)
  o:setColor(color)

  return o
end

-- {GMLightAPI]----------------------------------------------------------------

GMLightAPI = GMLightAPI or {}

---@type table<string,table>
GMLightAPI.FreakyLights = GMLightAPI.FreakyLights or {}

---@param name string
---@param x number
---@param y number
---@param z number
---@param newColor table
function GMLightAPI.SetLightColorAt(name, x, y, z, newColor)
  local id = GMUtils.PositionToId(x, y, z)
  if GMLightAPI.FreakyLights[id] and GMLightAPI.FreakyLights[id][name] then
    GMLightAPI.FreakyLights[id][name]:setColor(newColor)
  end
end

---@param name string
---@param x number
---@param y number
---@param z number
---@param newRadius number
function GMLightAPI.SetLightRadiusAt(name, x, y, z, newRadius)
  local id = GMUtils.PositionToId(x, y, z)
  if GMLightAPI.FreakyLights[id] and GMLightAPI.FreakyLights[id][name] then
    GMLightAPI.FreakyLights[id][name]:setRadius(newRadius)
  end
end

---@param name string
---@param x number
---@param y number
---@param z number
---@param radius number
---@param color table
function GMLightAPI.AddLightAt(name, x, y, z, radius, color)
  local id = GMUtils.PositionToId(x, y, z)
  if not GMLightAPI.FreakyLights[id] then
    GMLightAPI.FreakyLights[id] = {}
  end
  if GMLightAPI.FreakyLights[id] and GMLightAPI.FreakyLights[id][name] then
    GMLightAPI.FreakyLights[id][name]:destroy()
    GMLightAPI.FreakyLights[id][name] = nil
  end

  GMLightAPI.FreakyLights[id][name] = FreakyLightObject:new(name, x ,y, z, radius, color)
  if GMLights.debug then print("Light ['" ..name.. "'] added at x:" ..x.. " y:" ..y.. " z:" ..z) end
end

---@param name string
---@param x number
---@param y number
---@param z number
function GMLightAPI.RemoveLightAt(name, x, y, z)
  local id = GMUtils.PositionToId(x, y, z)
  if GMLightAPI.FreakyLights[id] and GMLightAPI.FreakyLights[id][name] then
    GMLightAPI.FreakyLights[id][name]:destroy()
    GMLightAPI.FreakyLights[id][name] = nil
    if GMLights.debug then print("Light ['" ..name.. "'] removed at x:" .. x .. " y:" .. y .. " z:" .. z) end
  end
end

---@param square IsoGridSquare
function GMLightAPI.onLoadGridsquare(square)
  local id = GMUtils.SquareToId(square)
  if GMLightAPI.FreakyLights[id] then
    ---@param v LightObject
    for _, v in pairs(GMLightAPI.FreakyLights[id]) do
      v:destroy()
      v:update()
    end
  end
end
Events.LoadGridsquare.Add(GMLightAPI.onLoadGridsquare)

-- [GMLights]------------------------------------------------------------------

function GMLights.addLightSource(isoLightSource)
  if isoLightSource == nil then return end
  for i = 1, #GMLights.sources do
    if GMLights.sources[i] == isoLightSource then return end
  end
  GMLightAPI.AddLightAt("freaky_light", isoLightSource:getX(), isoLightSource:getY(), isoLightSource:getZ(), isoLightSource:getRadius(), {r=GMLights.PULSE_R_VALUE, g=0.0, b=0.0, a = 1.0})
  table.insert(GMLights.sources, isoLightSource);
  if GMLights.debug then print("Added lightsource") end
end

function GMLights.doSquareScan(x, y, z)
  local square = getCell():getGridSquare(x, y, z)
  if square == nil then return end
  if GMLights.debug then
    local roomName = "NOT ROOM"
    local isoRoom = square:getRoom()
    if isoRoom then 
      roomName = isoRoom:getName()
    end        
    -- print("doSquareScan: " .. roomName)
    -- print("# of Objects: ", tostring(square:getObjects():size())) 
  end
  
  for i = 0, square:getObjects():size() - 1, 1 do
    local object = square:getObjects():get(i)
    local lights = nil
    if tostring(object:getType()) == 'lightswitch' then
      local lights = object:getLights()
    elseif object:getSprite() and object:getSprite():getName() and GMUtils.startsWith("lighting_outdoor", object:getSprite():getName()) then
      -- find streetlight switch
      --if GMLights.debug then print("Lightswitch base found") end
      local sq = getSquare(square:getX(), square:getY(), square:getZ() + 1)
      --if GMLights.debug then print("# of Objects, z + 1: ", tostring(sq:getObjects():size())) end
      for j = 0, sq:getObjects():size() - 1, 1 do
        local oj = sq:getObjects():get(j)
        --if GMLights.debug then print("Object type: ", tostring(oj:getType())) end
        if tostring(oj:getType()) == 'lightswitch' then
          lights = oj:getLights()
          break -- out of inner loop
        end
      end
    end
    if lights then
      --if GMLights.debug then print("# of Lights: ", tostring(lights:size())) end
      for k = 0, lights:size() - 1, 1 do 
        GMLights.addLightSource(lights:get(k))
      end
    end
  end
end

function GMLights.doFreakyLightDetails(player, pulse)
  if GMLights.busy then return end
  GMLights.busy = true
  for id, topTable in pairs(GMLightAPI.FreakyLights) do
    --if GMLights.debug then print("(id, topTable): ", tostring(id), type(topTable)) end
    for name, innerTable in pairs(topTable) do
      --if GMLights.debug then print("(name, innerTable): ", tostring(name), type(innerTable)) end
      local flX, flY, flZ, flA = 0, 0, 0, 0.0
      local radius = 0
      for property, value in pairs(innerTable) do
        --if GMLights.debug then print("(property, value): ", tostring(property), type(value), tostring(value)) end
        if property == "position" then
          flX = value["x"]
          flY = value["y"]
          flZ = value["z"]
        elseif property == "radius" then
          radius = value  
        elseif property == "color" then
          flA = value["a"]
        end                
      end
      if flX ~= 0 and radius ~= 0 then
        local sourceSquare = getCell():getGridSquare(flX, flY, flZ)
        if sourceSquare ~= nil then
          --if GMLights.debug then print("Checking room id: ", tostring(sourceSquare:getRoomID()), tostring(player:getCurrentSquare():getRoomID())) end
          local distance = IsoUtils.DistanceTo(flX, flY, 0.0, player:getX(), player:getY(), 0.0)      
          --if GMLights.debug then print("Checking distance/radius: ", tostring(distance), tostring(radius)) end
          -- Must be same room, within radius
          if sourceSquare:getRoomID() == player:getCurrentSquare():getRoomID() and distance <= radius then  
            if pulse then
              GMLights.pulseCount = GMLights.pulseCount + 1
              local newA = (math.sin(GMLights.pulseCount / GMLights.SINE_WIDTH) + 1) / 2.0
              if newA > 1.0 then
                if GMLights.debug then print("newA > 1.0: ", tostring(distance),  tostring(radius), tostring(newA)) end
                newA = 1.0
              elseif newA < 0.0 then
                if GMLights.debug then print("newA < 0.0: ", tostring(distance),  tostring(radius), tostring(newA)) end
                newA = 0.0
              end
              --if GMLights.debug then print("newA = ", tostring(newA)) end
              GMLightAPI.SetLightColorAt(name, flX, flY, flZ, {r = newA, g = 0.0, b = 0.0, a = 0.0})
            else
              --if GMLights.debug then print("distance/gb: ", tostring(distance),  tostring(gb)) end
              --change lightsource's rgb 
              local newR = 1.0 - (distance / (radius + 0.0)) * GMLights.START_RGB
              if newR > 1.0 then
                if GMLights.debug then print("newR > 1.0: ", tostring(distance),  tostring(radius), tostring(newR)) end
                newR = 1.0
              elseif newR < 0.0 then
                if GMLights.debug then print("newR < 0.0: ", tostring(distance),  tostring(radius), tostring(newR)) end
                newR = 0.0
              end
              --if GMLights.debug then print("newR = ", tostring(newR)) end
              GMLightAPI.SetLightColorAt(name, flX, flY, flZ, {r = newR, g = 0.0, b = 0.0, a = 1.0})
            end
          elseif flA > 0.0 then
            --switch light "off" (only if it is still "on") when out of range or not the same room
            GMLightAPI.SetLightColorAt(name, flX, flY, flZ, {r = GMLights.PULSE_R_VALUE, g = 0.0, b = 0.0, a = 0.0})
          end
        end
      end      
    end
  end 
  GMLights.busy = false
end

-- Not working as well as what I's like it to work, need to think about this more
GMLights.update = function(player)
  --GMLights.doFreakyLightDetails(player, true)
end

function GMLights.daily(insanityFactor)
  local factor = 0.5/5
  GMLights.meanness = GMUtils.changeMeanness(insanityFactor, GMLights.initMeanness, GMLights.meanness, factor)
end

-- Scan a block of square around the player evertime they move
function GMLights.playerMove(player)
  local distance = GMLights.SCAN_RADIUS
  
  local y = player:getY() - distance
  for x = player:getX() - distance, player:getX() + distance do
    GMLights.doSquareScan(x, y, player:getZ())
  end    
  y = player:getY() + distance
  for x = player:getX() - distance, player:getX() + distance do
    GMLights.doSquareScan(x, y, player:getZ())
  end
  
  local x = player:getX() - distance
  for y = player:getY() - distance + 1, player:getY() + distance - 1 do
    GMLights.doSquareScan(x, y, player:getZ())
  end
  x = player:getX() + distance
  for y = player:getY() - distance + 1, player:getY() + distance - 1 do
    GMLights.doSquareScan(x, y, player:getZ())
  end
  GMLights.doFreakyLightDetails(player, false)
end
-- For now, we are not following GM's main method
Events.OnPlayerMove.Add(GMLights.playerMove)
