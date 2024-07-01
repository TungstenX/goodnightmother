local function leadingSpace(spaces)
  local ret = ""
  for _ = 0, spaces, 1 do
    ret = ret .. "  "
  end
  return ret
end

local function printItem(item, spaces)
  local tabSpace = leadingSpace(spaces)
  if item == nil then
    print(tabSpace .. "Item is nil")
    return
  end
  local output = "\n"
  --output = output .. tabSpace .. "allowRandomTint|               " .. tostring(item:allowRandomTint() or "nil") .. "\n"  
  --output = output .. tabSpace .. "canBeActivated|                " .. tostring(item:canBeActivated() or "nil") .. "\n"
  --output = output .. tabSpace .. "canBeRemote|                   " .. tostring(item:canBeRemote() or "nil") .. "\n"
  --output = output .. tabSpace .. "canEmitLight|                  " .. tostring(item:canEmitLight() or "nil") .. "\n"
  output = output .. tabSpace .. "canStoreWater|                 " .. tostring(item:canStoreWater() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getA|                          " .. tostring(item:getA() or "nil") .. "\n" 
  --output = output .. tabSpace .. "getActualWeight|               " .. tostring(item:getActualWeight() or "nil") .. "\n"
  --output = output .. tabSpace .. "getAge|                        " .. tostring(item:getAge() or "nil") .. "\n"
  --output = output .. tabSpace .. "getAlcoholPower|               " .. tostring(item:getAlcoholPower() or "nil") .. "\n"
  --output = output .. tabSpace .. "getAlternateModelName|         " .. tostring(item:getAlternateModelName() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getAmmoType|                   " .. tostring(item:getAmmoType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getAttachedSlot|               " .. tostring(item:getAttachedSlot() or "nil") .. "\n"
  --output = output .. tabSpace .. "getAttachedSlotType|           " .. tostring(item:getAttachedSlotType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getAttachedToModel|            " .. tostring(item:getAttachedToModel() or "nil") .. "\n"
  --output = output .. tabSpace .. "getAttachmentReplacement|      " .. tostring(item:getAttachmentReplacement() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getAttachmentsProvided|        " .. tostring(item:getAttachmentsProvided() or "nil") .. "\n"   
  --output = output .. tabSpace .. "getAttachmentType|             " .. tostring(item:getAttachmentType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getB|                          " .. tostring(item:getB() or "nil") .. "\n"
  --output = output .. tabSpace .. "getBandagePower|               " .. tostring(item:getBandagePower() or "nil") .. "\n"
  --output = output .. tabSpace .. "getBloodClothingType|          " .. tostring(item:getBloodClothingType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getBodyLocation|               " .. tostring(item:getBodyLocation() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getBoredomChange|              " .. tostring(item:getBoredomChange() or "nil") .. "\n"
  --output = output .. tabSpace .. "getBrakeForce|                 " .. tostring(item:getBrakeForce() or "nil") .. "\n"
  --output = output .. tabSpace .. "getBreakSound|                 " .. tostring(item:getBreakSound() or "nil") .. "\n"
  --output = output .. tabSpace .. "getBringToBearSound|           " .. tostring(item:getBringToBearSound() or "nil") .. "\n"
  --output = output .. tabSpace .. "getBurntString|                " .. tostring(item:getBurntString() or "nil") .. "\n"
  
  output = output .. tabSpace .. "getCat|                        " .. tostring(item:getCat() or "nil") .. "\n"
  output = output .. tabSpace .. "getCategory|                   " .. tostring(item:getCategory() or "nil") .. "\n"
  --output = output .. tabSpace .. "getChanceToSpawnDamaged|       " .. tostring(item:getChanceToSpawnDamaged() or "nil") .. "\n"
  --output = output .. tabSpace .. "getClothingItem|               " .. tostring(item:getClothingItem() or "nil") .. "\n"
  --output = output .. tabSpace .. "getClothingItemExtra|          " .. tostring(item:getClothingItemExtra() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getClothingItemExtraOption|    " .. tostring(item:getClothingItemExtraOption() or "nil") .. "\n"
  --output = output .. tabSpace .. "getClothingItemName|           " .. tostring(item:getClothingItemName() or "nil") .. "\n"
  --output = output .. tabSpace .. "getColor|                      " .. tostring(item:getColor() or "nil") .. "\n"
  --output = output .. tabSpace .. "getColorBlue|                  " .. tostring(item:getColorBlue() or "nil") .. "\n"
  --output = output .. tabSpace .. "getColorGreen|                 " .. tostring(item:getColorGreen() or "nil") .. "\n"

  --output = output .. tabSpace .. "getColorInfo|                  " .. tostring(item:getColorInfo() or "nil") .. "\n"
  --output = output .. tabSpace .. "getColorRed|                   " .. tostring(item:getColorRed() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCondition|                  " .. tostring(item:getCondition() or "nil") .. "\n"
  --output = output .. tabSpace .. "getConditionLowerNormal|       " .. tostring(item:getConditionLowerNormal() or "nil") .. "\n"
  --output = output .. tabSpace .. "getConditionLowerOffroad|      " .. tostring(item:getConditionLowerOffroad() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getConditionMax|               " .. tostring(item:getConditionMax() or "nil") .. "\n"
  --output = output .. tabSpace .. "getConsolidateOption|          " .. tostring(item:getConsolidateOption() or "nil") .. "\n"
  --output = output .. tabSpace .. "getContainer|                  " .. tostring(item:getContainer() or "nil") .. "\n"
  --output = output .. tabSpace .. "getContainerX|                 " .. tostring(item:getContainerX() or "nil") .. "\n"
  --output = output .. tabSpace .. "getContainerY|                 " .. tostring(item:getContainerY() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getContentsWeight|             " .. tostring(item:getContentsWeight() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCookedString|               " .. tostring(item:getCookedString() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCookingTime|                " .. tostring(item:getCookingTime() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCount|                      " .. tostring(item:getCount() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCountDownSound|             " .. tostring(item:getCountDownSound() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getCurrentAmmoCount|           " .. tostring(item:getCurrentAmmoCount() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCurrentCondition|           " .. tostring(item:getCurrentCondition() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCurrentUses|                " .. tostring(item:getCurrentUses() or "nil") .. "\n"
  --output = output .. tabSpace .. "getCustomMenuOption|           " .. tostring(item:getCustomMenuOption() or "nil") .. "\n"
  --output = output .. tabSpace .. "getDescription|                " .. tostring(item:getDescription() or "nil") .. "\n"
  
  output = output .. tabSpace .. "getDisplayCategory|            " .. tostring(item:getDisplayCategory() or "nil") .. "\n"
  output = output .. tabSpace .. "getDisplayName|                " .. tostring(item:getDisplayName() or "nil") .. "\n"
  output = output .. tabSpace .. "getEatType|                    " .. tostring(item:getEatType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getEngineLoudness|             " .. tostring(item:getEngineLoudness() or "nil") .. "\n"
  --output = output .. tabSpace .. "getEquipParent|                " .. tostring(item:getEquipParent() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getEquippedWeight|             " .. tostring(item:getEquippedWeight() or "nil") .. "\n"
  --output = output .. tabSpace .. "getEquipSound|                 " .. tostring(item:getEquipSound() or "nil") .. "\n"
  output = output .. tabSpace .. "getEvolvedRecipeName|          " .. tostring(item:getEvolvedRecipeName() or "nil") .. "\n"
  --output = output .. tabSpace .. "getExplosionSound|             " .. tostring(item:getExplosionSound() or "nil") .. "\n"
  output = output .. tabSpace .. "getExtraItems|                 " .. tostring(item:getExtraItems() or "nil") .. "\n"
  
  output = output .. tabSpace .. "getExtraItemsWeight|           " .. tostring(item:getExtraItemsWeight() or "nil") .. "\n"
  --output = output .. tabSpace .. "getFabricType|                 " .. tostring(item:getFabricType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getFatigueChange|              " .. tostring(item:getFatigueChange() or "nil") .. "\n"
  --output = output .. tabSpace .. "getFillFromDispenserSound|     " .. tostring(item:getFillFromDispenserSound() or "nil") .. "\n"
  --output = output .. tabSpace .. "getFillFromTapSound|           " .. tostring(item:getFillFromTapSound() or "nil") .. "\n"
  
  output = output .. tabSpace .. "getFullType|                   " .. tostring(item:getFullType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getG|                          " .. tostring(item:getG() or "nil") .. "\n"
  --output = output .. tabSpace .. "getGunType|                    " .. tostring(item:getGunType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getHaveBeenRepaired|           " .. tostring(item:getHaveBeenRepaired() or "nil") .. "\n"
  --output = output .. tabSpace .. "getHotbarEquippedWeight|       " .. tostring(item:getHotbarEquippedWeight() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getIconsForTexture|            " .. tostring(item:getIconsForTexture() or "nil") .. "\n"
  output = output .. tabSpace .. "getID|                         " .. tostring(item:getID() or "nil") .. "\n"
  --output = output .. tabSpace .. "getInvHeat|                    " .. tostring(item:getInvHeat() or "nil") .. "\n"
  --output = output .. tabSpace .. "getItemCapacity|               " .. tostring(item:getItemCapacity() or "nil") .. "\n"
  --output = output .. tabSpace .. "getItemHeat|                   " .. tostring(item:getItemHeat() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getItemReplacementPrimaryHand| " .. tostring(item:getItemReplacementPrimaryHand() or "nil") .. "\n"
  --output = output .. tabSpace .. "getItemReplacementSecondHand|  " .. tostring(item:getItemReplacementSecondHand() or "nil") .. "\n"
  --output = output .. tabSpace .. "getItemWhenDry|                " .. tostring(item:getItemWhenDry() or "nil") .. "\n"
  --output = output .. tabSpace .. "getJobDelta|                   " .. tostring(item:getJobDelta() or "nil") .. "\n"
  --output = output .. tabSpace .. "getJobType|                    " .. tostring(item:getJobType() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getKeyId|                      " .. tostring(item:getKeyId() or "nil") .. "\n"
  --output = output .. tabSpace .. "getLastAged|                   " .. tostring(item:getLastAged() or "nil") .. "\n"
  --output = output .. tabSpace .. "getLightDistance|              " .. tostring(item:getLightDistance() or "nil") .. "\n"
  --output = output .. tabSpace .. "getLightStrength|              " .. tostring(item:getLightStrength() or "nil") .. "\n"
  --output = output .. tabSpace .. "getLuaCreate|                  " .. tostring(item:getLuaCreate() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getMakeUpType|                 " .. tostring(item:getMakeUpType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMaxAmmo|                    " .. tostring(item:getMaxAmmo() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMaxCapacity|                " .. tostring(item:getMaxCapacity() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMechanicType|               " .. tostring(item:getMechanicType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMediaData|                  " .. tostring(item:getMediaData() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getMediaType|                  " .. tostring(item:getMediaType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMeltingTime|                " .. tostring(item:getMeltingTime() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMetalValue|                 " .. tostring(item:getMetalValue() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMinutesToBurn|              " .. tostring(item:getMinutesToBurn() or "nil") .. "\n"
  --output = output .. tabSpace .. "getMinutesToCook|              " .. tostring(item:getMinutesToCook() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getModData|                    " .. tostring(item:getModData() or "nil") .. "\n"
  --output = output .. tabSpace .. "getModID|                      " .. tostring(item:getModID() or "nil") .. "\n"
  --output = output .. tabSpace .. "getModName|                    " .. tostring(item:getModName() or "nil") .. "\n"
  --output = output .. tabSpace .. "getModule|                     " .. tostring(item:getModule() or "nil") .. "\n"
  output = output .. tabSpace .. "getName|                       " .. tostring(item:getName() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getNewPlaceDir|                " .. tostring(item:getNewPlaceDir() or "nil") .. "\n"
  --output = output .. tabSpace .. "getOffAge|                     " .. tostring(item:getOffAge() or "nil") .. "\n"
  --output = output .. tabSpace .. "getOffAgeMax|                  " .. tostring(item:getOffAgeMax() or "nil") .. "\n"
  --output = output .. tabSpace .. "getOffString|                  " .. tostring(item:getOffString() or "nil") .. "\n"
  --output = output .. tabSpace .. "getOutermostContainer|         " .. tostring(item:getOutermostContainer() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getPlaceDir|                   " .. tostring(item:getPlaceDir() or "nil") .. "\n"
  --output = output .. tabSpace .. "getPlaceMultipleSound|         " .. tostring(item:getPlaceMultipleSound() or "nil") .. "\n"
  --output = output .. tabSpace .. "getPlaceOneSound|              " .. tostring(item:getPlaceOneSound() or "nil") .. "\n"
  --output = output .. tabSpace .. "getPreviousOwner|              " .. tostring(item:getPreviousOwner() or "nil") .. "\n"
  --output = output .. tabSpace .. "getR|                          " .. tostring(item:getR() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getRecordedMediaIndex|         " .. tostring(item:getRecordedMediaIndex() or "nil") .. "\n"
  --output = output .. tabSpace .. "getReduceInfectionPower|       " .. tostring(item:getReduceInfectionPower() or "nil") .. "\n"
  --output = output .. tabSpace .. "getRegistry_id|                " .. tostring(item:getRegistry_id() or "nil") .. "\n"
  --output = output .. tabSpace .. "getRemoteControlID|            " .. tostring(item:getRemoteControlID() or "nil") .. "\n"
  --output = output .. tabSpace .. "getRemoteRange|                " .. tostring(item:getRemoteRange() or "nil") .. "\n"
  
  output = output .. tabSpace .. "getReplaceOnUse|               " .. tostring(item:getReplaceOnUse() or "nil") .. "\n"
  output = output .. tabSpace .. "getReplaceOnUseFullType|       " .. tostring(item:getReplaceOnUseFullType() or "nil") .. "\n"
  output = output .. tabSpace .. "getReplaceOnUseOn|             " .. tostring(item:getReplaceOnUseOn() or "nil") .. "\n"
  --output = output .. tabSpace .. "getReplaceOnUseOnString|       " .. tostring(item:getReplaceOnUseOnString() or "nil") .. "\n"  
  output = output .. tabSpace .. "getReplaceTypesMap|            " .. tostring(item:getReplaceTypesMap() or "nil") .. "\n"
  output = output .. tabSpace .. "getReplaceTypes|               " .. tostring(item:getReplaceTypes() or "nil") .. "\n"
  
  output = output .. tabSpace .. "getRequireInHandOrInventory|   " .. tostring(item:getRequireInHandOrInventory() or "nil") .. "\n"
  --output = output .. tabSpace .. "getRightClickContainer|        " .. tostring(item:getRightClickContainer() or "nil") .. "\n"
  --output = output .. tabSpace .. "getSaveType|                   " .. tostring(item:getSaveType() or "nil") .. "\n"
  output = output .. tabSpace .. "getScriptItem|                 " .. tostring(item:getScriptItem() or "nil") .. "\n"
  --output = output .. tabSpace .. "getStaticModel|                " .. tostring(item:getStaticModel() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getStressChange|               " .. tostring(item:getStressChange() or "nil") .. "\n"
  output = output .. tabSpace .. "getStringItemType|             " .. tostring(item:getStringItemType() or "nil") .. "\n"
  --output = output .. tabSpace .. "getSuspensionCompression|      " .. tostring(item:getSuspensionCompression() or "nil") .. "\n"
  --output = output .. tabSpace .. "getSuspensionDamping|          " .. tostring(item:getSuspensionDamping() or "nil") .. "\n"
  --output = output .. tabSpace .. "getSwingAnim|                  " .. tostring(item:getSwingAnim() or "nil") .. "\n"

  output = output .. tabSpace .. "getTags|                       " .. tostring(item:getTags() or "nil") .. "\n"
  output = output .. tabSpace .. "getTaken|                      " .. tostring(item:getTaken() or "nil") .. "\n"
  --output = output .. tabSpace .. "getTex|                        " .. tostring(item:getTex() or "nil") .. "\n"
  --output = output .. tabSpace .. "getTexture|                    " .. tostring(item:getTexture() or "nil") .. "\n"
  --output = output .. tabSpace .. "getTextureBurnt|               " .. tostring(item:getTextureBurnt() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getTextureBurnt|               " .. tostring(item:getTextureBurnt() or "nil") .. "\n"
  --output = output .. tabSpace .. "getTexturerotten|              " .. tostring(item:getTexturerotten() or "nil") .. "\n"
  --output = output .. tabSpace .. "getTooltip|                    " .. tostring(item:getTooltip() or "nil") .. "\n"
  --output = output .. tabSpace .. "getTorchDot|                   " .. tostring(item:getTorchDot() or "nil") .. "\n"
  output = output .. tabSpace .. "getType|                       " .. tostring(item:getType() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getUnCookedString|             " .. tostring(item:getUnCookedString() or "nil") .. "\n"
  --output = output .. tabSpace .. "getUnequippedWeight|           " .. tostring(item:getUnequippedWeight() or "nil") .. "\n"
  --output = output .. tabSpace .. "getUnequipSound|               " .. tostring(item:getUnequipSound() or "nil") .. "\n"
  --output = output .. tabSpace .. "getUnhappyChange|              " .. tostring(item:getUnhappyChange() or "nil") .. "\n"
  --output = output .. tabSpace .. "getVisual|                     " .. tostring(item:getVisual() or "nil") .. "\n"
  
  output = output .. tabSpace .. "getWeight|                     " .. tostring(item:getWeight() or "nil") .. "\n"
  --output = output .. tabSpace .. "getWetCooldown|                " .. tostring(item:getWetCooldown() or "nil") .. "\n"
  --output = output .. tabSpace .. "getWheelFriction|              " .. tostring(item:getWheelFriction() or "nil") .. "\n"
  --output = output .. tabSpace .. "getWorker|                     " .. tostring(item:getWorker() or "nil") .. "\n"
  --output = output .. tabSpace .. "getWorldItem|                  " .. tostring(item:getWorldItem() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "getWorldStaticItem|            " .. tostring(item:getWorldStaticItem() or "nil") .. "\n"
  --output = output .. tabSpace .. "getWorldTexture|               " .. tostring(item:getWorldTexture() or "nil") .. "\n"
  --output = output .. tabSpace .. "hasBlood|                      " .. tostring(item:hasBlood() or "nil") .. "\n"
  --output = output .. tabSpace .. "hasDirt|                       " .. tostring(item:hasDirt() or "nil") .. "\n"
  --output = output .. tabSpace .. "hasModData|                    " .. tostring(item:hasModData() or "nil") .. "\n"
  
  output = output .. tabSpace .. "haveExtraItems|                " .. tostring(item:haveExtraItems() or "nil") .. "\n"
  output = output .. tabSpace .. "HowRotten|                     " .. tostring(item:HowRotten() or "nil") .. "\n"
  --output = output .. tabSpace .. "isActivated|                   " .. tostring(item:isActivated() or "nil") .. "\n"
  --output = output .. tabSpace .. "isAlcoholic|                   " .. tostring(item:isAlcoholic() or "nil") .. "\n"
  --output = output .. tabSpace .. "isAlwaysWelcomeGift|           " .. tostring(item:isAlwaysWelcomeGift() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "isBeingFilled|                 " .. tostring(item:isBeingFilled() or "nil") .. "\n"
  --output = output .. tabSpace .. "isBroken|                      " .. tostring(item:isBroken() or "nil") .. "\n"
  --output = output .. tabSpace .. "isBurnt|                       " .. tostring(item:isBurnt() or "nil") .. "\n"
  --output = output .. tabSpace .. "isCanBandage|                  " .. tostring(item:isCanBandage() or "nil") .. "\n"
  --output = output .. tabSpace .. "IsClothing|                    " .. tostring(item:IsClothing() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "isConditionAffectsCapacity|    " .. tostring(item:isConditionAffectsCapacity() or "nil") .. "\n"
  output = output .. tabSpace .. "isCookable|                    " .. tostring(item:isCookable() or "nil") .. "\n"
  output = output .. tabSpace .. "isCooked|                      " .. tostring(item:isCooked() or "nil") .. "\n"
  --output = output .. tabSpace .. "isCustomColor|                 " .. tostring(item:isCustomColor() or "nil") .. "\n"
  --output = output .. tabSpace .. "isCustomName|                  " .. tostring(item:isCustomName() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "isCustomWeight|                " .. tostring(item:isCustomWeight() or "nil") .. "\n"
  --output = output .. tabSpace .. "isDisappearOnUse|              " .. tostring(item:isDisappearOnUse() or "nil") .. "\n"
  output = output .. tabSpace .. "IsDrainable|                   " .. tostring(item:IsDrainable() or "nil") .. "\n"
  --output = output .. tabSpace .. "isEmittingLight|               " .. tostring(item:isEmittingLight() or "nil") .. "\n"
  --output = output .. tabSpace .. "isEquipped|                    " .. tostring(item:isEquipped() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "isEquippedNoSprint|            " .. tostring(item:isEquippedNoSprint() or "nil") .. "\n"
  --output = output .. tabSpace .. "isFavorite|                    " .. tostring(item:isFavorite() or "nil") .. "\n"
  --output = output .. tabSpace .. "isFishingLure|                 " .. tostring(item:isFishingLure() or "nil") .. "\n"
  output = output .. tabSpace .. "IsFood|                        " .. tostring(item:IsFood() or "nil") .. "\n"
  --output = output .. tabSpace .. "isHairDye|                     " .. tostring(item:isHairDye() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "isHidden|                      " .. tostring(item:isHidden() or "nil") .. "\n"
  --output = output .. tabSpace .. "isInfected|                    " .. tostring(item:isInfected() or "nil") .. "\n"
  --output = output .. tabSpace .. "isInitialised|                 " .. tostring(item:isInitialised() or "nil") .. "\n"
  --output = output .. tabSpace .. "isInLocalPlayerInventory|      " .. tostring(item:isInLocalPlayerInventory() or "nil") .. "\n"
  output = output .. tabSpace .. "isInPlayerInventory|           " .. tostring(item:isInPlayerInventory() or "nil") .. "\n"
  
  output = output .. tabSpace .. "IsInventoryContainer|          " .. tostring(item:IsInventoryContainer() or "nil") .. "\n"
  output = output .. tabSpace .. "isIsCookable|                  " .. tostring(item:isIsCookable() or "nil") .. "\n"
  --output = output .. tabSpace .. "IsLiterature|                  " .. tostring(item:IsLiterature() or "nil") .. "\n"
  --output = output .. tabSpace .. "IsMap|                         " .. tostring(item:IsMap() or "nil") .. "\n"
  --output = output .. tabSpace .. "isProtectFromRainWhileEquipped|" .. tostring(item:isProtectFromRainWhileEquipped() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "isRecordedMedia|               " .. tostring(item:isRecordedMedia() or "nil") .. "\n"
  --output = output .. tabSpace .. "isRemoteController|            " .. tostring(item:isRemoteController() or "nil") .. "\n"
  --output = output .. tabSpace .. "isRequiresEquippedBothHands|   " .. tostring(item:isRequiresEquippedBothHands() or "nil") .. "\n"
  output = output .. tabSpace .. "IsRotten|                      " .. tostring(item:IsRotten() or "nil") .. "\n"
  output = output .. tabSpace .. "isTaintedWater|                " .. tostring(item:isTaintedWater() or "nil") .. "\n"
  
  --output = output .. tabSpace .. "isTorchCone|                   " .. tostring(item:isTorchCone() or "nil") .. "\n"
  --output = output .. tabSpace .. "isTrap|                        " .. tostring(item:isTrap() or "nil") .. "\n"
  --output = output .. tabSpace .. "isTwoHandWeapon|               " .. tostring(item:isTwoHandWeapon() or "nil") .. "\n"
  --output = output .. tabSpace .. "isUseWorldItem|                " .. tostring(item:isUseWorldItem() or "nil") .. "\n"
  --output = output .. tabSpace .. "isVanilla|                     " .. tostring(item:isVanilla() or "nil") .. "\n"
  
  output = output .. tabSpace .. "isWaterSource|                 " .. tostring(item:isWaterSource() or "nil") .. "\n"
  --output = output .. tabSpace .. "IsWeapon|                      " .. tostring(item:IsWeapon() or "nil") .. "\n"
  --output = output .. tabSpace .. "isWet|                         " .. tostring(item:isWet() or "nil") .. "\n"
  print(output)
end

local function tableToString(t, spaces)
  if spaces > 7 then
    return ""
  end
  local tabSpace = leadingSpace(spaces)
  local ret = ""
  for k, v in pairs(t) do
    ret = ret .. tabSpace .. "(" .. k .. "): "
    if instanceof(v, 'table') then
      local newSpaces = spaces + 1
      local newTabSpace = leadingSpace(newSpaces)
      ret = ret .. tableToString(v, newSpaces)
    else
      ret = ret .. tostring(v)
    end
    ret = ret .. "\n"
  end
  return ret
end

local function fill(playerID, context, items)
  items = ISInventoryPane.getActualItems(items)
  for _,item in ipairs(items) do
    print("***### Item (" .. _ .. ") ###***")
    printItem(item, 1)
  end
end

local function testPreFill(playerID, context, items)
  
  --print("***### Pre Fill ###***")
  --fill(playerID, context, items)
  --print("***###___###***")
end

--Events.OnPreFillInventoryObjectContextMenu.Add(testPreFill)