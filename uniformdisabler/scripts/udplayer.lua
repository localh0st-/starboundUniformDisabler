require("/scripts/udrecruitspawner.lua")

function offerUniformUpdate(recruitUuid, entityId)
  local recruit = recruitSpawner:getRecruit(recruitUuid)
  if not recruit then return end

  if not recruitSpawner.customUniform then
    local dialogConfig = createConfirmationDialog("/interface/confirmation/setuniformconfirmation.config", recruit)
    dialogConfig.sourceEntityId = entityId
    dialogConfig.images.portrait = world.entityPortrait(entity.id(), "full")
    promises:add(player.confirm(dialogConfig), function (choice)
        if choice then
          updateCustomUniform()
        end
      end)
  else
    local dialogConfig = createConfirmationDialog("/interface/confirmation/resetuniformconfirmation.config", recruit)
    dialogConfig.sourceEntityId = entityId
    dialogConfig.images.portrait = world.entityPortrait(entity.id(), "full")
    promises:add(player.confirm(dialogConfig), function (choice)
        if choice then
          resetCustomUniform()
        end
      end)
  end
end

function resetCustomUniform()
  sb.logInfo("foo")
end

function updateCustomUniform()
  sb.logInfo("bar")
end