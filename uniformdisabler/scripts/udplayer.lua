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
  local minions=playerCompanions.getCompanions("crew")
  sb.logWarn("%s",minions[1]["uniqueId"])
  for _,member in pairs(minions) do
    world.sendEntityMessage(member["uniqueId"],"recruit.homeClothes")
  end
end

function updateCustomUniform()
  local minions=playerCompanions.getCompanions("crew")
  --sb.logWarn("%s",minions[1]["uniqueId"])
  for _,member in pairs(minions) do
    sb.logWarn("%s",member["uniqueId"])
    world.sendEntityMessage(member["uniqueId"],"recruit.forcedClothes")
  end
end