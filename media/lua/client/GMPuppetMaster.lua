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
│ GM Puppet Master │
└──────────────────┘
]]

GMPuppetMaster = GMPuppetMaster or {}
GMPuppetMaster.LOG = GMPuppetMaster.LOG or {}
GMPuppetMaster.LOG.debug =  getCore():getDebug() or false
GMPuppetMaster.LOG.trace = false

GMPuppetMaster.name = "PuppetMaster"
GMPuppetMaster.needScan = false
GMPuppetMaster.needOnSeeNewRoom = false
GMPuppetMaster.needUpdate = false
GMPuppetMaster.needSleepSpawn = false
GMPuppetMaster.spawnWeight = 10
GMPuppetMaster.meanness = 7
GMPuppetMaster.initMeanness = 7

GMPuppetMaster.MAX_DISTANCE = 20 -- TBD
GMPuppetMaster.NUMBER_OF_ZOMBIES = 10
GMPuppetMaster.zombies = {}

function GMPuppetMaster.findInList(zombie)
  for i = 1, #GMPuppetMaster.zombies do
    if GMPuppetMaster.zombies[i] == zombie then return zombie end
  end
  return nil
end

function GMPuppetMaster.removeZombie(zombie)
  for i = 1, #GMPuppetMaster.zombies do
    if GMPuppetMaster.zombies[i] == zombie then 
      if GMPuppetMaster.LOG.debug then print("Removing zombie from list") end
      GMPuppetMaster.zombies[i] = nil
      return
    end
  end
end

-- Is the zombie in the same cell as the player AND is the zombie within the max distance from the player
function GMPuppetMaster.inRange(zombie)
  local player = getPlayer()  
  return player:getCell() == zombie:getCell() and ((zombie:getX() - player:getX()) ^ 2  + (zombie:getY() - player:getY()) ^ 2) <= GMPuppetMaster.MAX_DISTANCE
end

function GMPuppetMaster.addZombie(zombie)
  -- only control X amount of zombies
  if #GMPuppetMaster.zombies > GMPuppetMaster.NUMBER_OF_ZOMBIES then return end
  -- must be same cell and not too far away
  if not GMPuppetMaster.inRange(zombie) then return end
  if GMPuppetMaster.findInList(zombie) == nil then
    if zombie:getModData() == nil then
      if GMPuppetMaster.LOG.debug then print("No moddata") end
    end
    local md = zombie:getModData()
    if md and md.GMPuppetMaster == nil then
      md.GMPuppetMaster = {}
    end
    md.GMPuppetMaster.state = nil
    table.insert(GMPuppetMaster.zombies, zombie)
  end
end

function GMPuppetMaster.OnZombieUpdate(zombie)
  GMPuppetMaster.addZombie(zombie)
  if GMPuppetMaster.findInList(zombie) ~= nil then
    if not GMPuppetMaster.inRange(zombie) then 
      GMPuppetMaster.removeZombie(zombie)
    else
      local md = zombie:getModData()
      if md and md.GMPuppetMaster ~= nil then
        if md.GMPuppetMaster.state ~= zombie:getCurrentState() then
          if GMPuppetMaster.LOG.debug then print("Zombie state changed from " .. tostring(md.GMPuppetMaster.state) .. " to" .. tostring(zombie:getCurrentState())) end
          md.GMPuppetMaster.state = zombie:getCurrentState()
          if GMPuppetMaster.LOG.debug then
            local debugOut = "\nZombie:" ..
            "\n\tGetAnimSetName:         " .. tostring(zombie:GetAnimSetName()) ..
            "\n\tgetRealState:           " .. tostring(zombie:getRealState()) ..
            "\n\tgetTarget:              " .. tostring(zombie:getTarget()) ..
            "\n\tgetHighlightColor:      " .. tostring(zombie:getHighlightColor()) ..
            "\n\tgetOutlineHighlightCol: " .. tostring(zombie:getOutlineHighlightCol())
            print(debugOut)
            local hc = ColorInfo.new(0.5411764979362488,0.6470588445663452,0.7176470756530762, 1)
            zombie:setHighlightColor(hc)  
            zombie:setOutlineHighlightCol(hc)
          end
        end
      elseif GMPuppetMaster.LOG.debug then 
        print("Update: No moddata.")
      end    	
    end
  end
end
Events.OnZombieUpdate.Add(GMPuppetMaster.OnZombieUpdate)
