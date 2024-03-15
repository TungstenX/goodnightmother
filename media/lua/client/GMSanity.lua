GMSanity = GMSanity or {}
GMSanity.debug = false

GMSanity.stressFactor = function(meanness)
  return 1.0 / (meanness + (2 * (10 - meanness) - 7)) * 6
end

GMSanity.panicFactor = function(meanness)
  return 2.5 - ((2.5 / 9.0) * (9.0 - meanness))
end

GMSanity.unhappyFactor = function(meanness)
  return 1.0 / (meanness + (2 * (10 - meanness) - 7)) * 6
end

GMSanity.sanityFactor = function(meanness)
  return 1.0 / (meanness + (2 * (10 - meanness) - 7)) * 6
end

GMSanity.moraleFactor = function(meanness)
  return 1.0 / (meanness + (2 * (10 - meanness) - 7)) * 6
end

function GMSanity.updateStats(player, meanness, multiplier)
  --change stats
  player:getStats():setStress(player:getStats():getStress() + ((meanness * GMSanity.stressFactor(meanness))) * multiplier)
  player:getStats():setPanic(player:getStats():getPanic() + ((meanness * GMSanity.panicFactor(meanness))) * multiplier)
  player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + ((meanness * GMSanity.unhappyFactor(meanness))) * multiplier)
  --player:getStats():setSanity(player:getStats():getSanity() - ((meanness * GMSanity.sanityFactor(meanness))) * multiplier)
  player:getStats():setMorale(player:getStats():getMorale() - ((meanness * GMSanity.moraleFactor(meanness))) * multiplier)
end

function GMSanity.sanityResponse(player, minutesDuration, maxHours)
  --Force wake
  if (minutesDuration / 60) >= maxHours then
    if player:isAsleep() then
      player:forceAwake()
    end
  end 
end
