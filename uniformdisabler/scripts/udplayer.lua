require("/scripts/udrecruitspawner.lua")

function offerUniformUpdate(recruitUuid, entityId)
  local recruit = recruitSpawner:getRecruit(recruitUuid)
  if not recruit then return end
  local lazyMinions=playerCompanions.getCompanions("followers")
  if lazyMinions[1] then
    local dialogConfig = createConfirmationDialog("/interface/confirmation/disableuniformconfirmation.config", recruit)
    dialogConfig.sourceEntityId = entityId
    dialogConfig.images.portrait = world.entityPortrait(entity.id(), "full")
    promises:add(player.confirm(dialogConfig), function (choice)
        if choice then
          updateCustomUniform()
        else
		  resetCustomUniform()
		end
      end)
  else
    local dialogConfig = createConfirmationDialog("/interface/confirmation/dutailorconfirmation.config", recruit)
    dialogConfig.sourceEntityId = entityId
    dialogConfig.images.portrait = world.entityPortrait(entity.id(), "full")
    promises:add(player.confirm(dialogConfig), function (choice)
        if choice then
          --updateCustomUniform()
		  local puni=getPlayerUniform()
		  sb.logWarn("tailor unifom works")
		  world.sendEntityMessage(entityId,"recruit.forcedClothes",puni)
		  recruitSpawner:markDirty()
        else
		  world.sendEntityMessage(entityId,"recruit.homeClothes")
		  recruitSpawner:markDirty()
		end
      end)
  end
end

function resetCustomUniform()
  local myMinions=playerCompanions.getCompanions("followers")
  local lazyMinions=playerCompanions.getCompanions("shipCrew")
  for _, member in pairs(myMinions) do
    world.sendEntityMessage(member["uniqueId"],"recruit.homeClothes")
  end
  recruitSpawner:markDirty()
end

function updateCustomUniform()
  local myMinions=playerCompanions.getCompanions("followers")
  local lazyMinions=playerCompanions.getCompanions("shipCrew")
  local puni=getPlayerUniform()
  for _, member in pairs(myMinions) do
    world.sendEntityMessage(member["uniqueId"],"recruit.forcedClothes",puni)
  end
 
  recruitSpawner:markDirty()
end