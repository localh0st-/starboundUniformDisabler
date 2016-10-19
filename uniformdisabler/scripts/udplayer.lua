require("/scripts/udrecruitspawner.lua")

function offerUniformUpdate(recruitUuid, entityId)
  local config = root.assetJson("/objects/test.config")
  sb.logWarn("%s",config.interactionConfig)
  return {"ScriptConsole", config.interactionConfig}

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