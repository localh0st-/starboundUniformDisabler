require("/scripts/udrecruitspawner.lua")

function offerUniformUpdate(recruitUuid, entityId)
  local recruit = recruitSpawner:getRecruit(recruitUuid)
  if not recruit then return end

  if not recruitSpawner.customUniform then
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
	end
end

function resetCustomUniform()
  local myMinions=playerCompanions.getCompanions("followers")
  local lazyMinions=playerCompanions.getCompanions("shipCrew")
  sb.logWarn("%s","reset uniform")
  for _, member in pairs(myMinions) do
    world.sendEntityMessage(member["uniqueId"],"recruit.homeClothes")
  end
  recruitSpawner:markDirty()
end

function updateCustomUniform()
  local myMinions=playerCompanions.getCompanions("followers")
  local lazyMinions=playerCompanions.getCompanions("shipCrew")
  sb.logWarn("%s","assign uniform")
  puni=getPlayerUniform()
  for _, member in pairs(myMinions) do
    world.sendEntityMessage(member["uniqueId"],"recruit.forcedClothes",puni)
  end
 
  recruitSpawner:markDirty()
end