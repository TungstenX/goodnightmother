GMCorpse = {}
GMCorpse.debug = false
GMCorpse.needScan = false
GMCorpse.needOnSeeNewRoom = false
GMCorpse.needUpdate = false
GMCorpse.needSleepSpawn = true
GMCorpse.spawnWeight = 10

-- Do nothing
GMCorpse.init = function()
end

--TODO: Where to put it and which way to face
--TODO: Find bed in room
--TODO: Sleep inARoom, vehicle, Tent etc
GMCorpse.spawn = function(player)
  local x, y, z = player:getX(), player:getY(), player:getZ()
  x = x + ZombRand(-2, 3)
  y = y + ZombRand(-2, 3)
  local zombie = createZombie(x, y, z, nil, 0, IsoDirections.S)
  zombie:dressInRandomOutfit()
  zombie:DoZombieInventory()
  local body = IsoDeadBody.new(zombie, false)
  body:setX(x)
  body:setY(y)
  body:setZ(z)
  body:addToWorld()
end