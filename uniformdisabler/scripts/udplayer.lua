require("/scripts/udrecruitspawner.lua")

udplayerinit=init
function init()
  udplayerinit()
  message.setHandler("recruits.test", simpleHandler(test))
end

function offerUniformUpdate(recruitUuid, entityId)


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

function test(Iop)
  sb.logWarn("%s",Iop)
  return playerCompanions.getCompanions("crew")
end