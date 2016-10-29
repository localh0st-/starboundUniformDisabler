require "/scripts/udrecruitspawner.lua"
-- initiates new player script
udplayerinit=init
function init()
  udplayerinit()
  message.setHandler("recruits.test", simpleHandler(test))
  message.setHandler("recruits.savetime", simpleHandler(savetime))
  message.setHandler("player.getPlayerUniform", simpleHandler(getPlayerUniform))
end


--tells recruit spawner that the crewmembers have been updated
function savetime()
  recruitSpawner:markDirty()
end
--gets the crew and crew paprameters
function test()
  return playerCompanions.getCompanions("crew")
end