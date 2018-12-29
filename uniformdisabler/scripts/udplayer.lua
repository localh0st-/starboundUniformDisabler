require "/scripts/udrecruitspawner.lua"
-- initiates new player script
udplayerinit=init
function init()
  udplayerinit()
  message.setHandler("recruits.test", simpleHandler(klonoa))
  message.setHandler("recruits.savetime", simpleHandler(savetime))
  message.setHandler("player.getPlayerUniform", simpleHandler(getPlayerUniform))--links to the vanilla function
end


--tells recruit spawner that the crewmembers have been updated and so their data should be updated in the recruitSpawner
function savetime()
  recruitSpawner:markDirty()
end
--gets the crew and crew paprameters
function klonoa()
   local followers = playerCompanions.getCompanions("followers")
   local crew = playerCompanions.getCompanions("shipCrew")
   util.appendLists(crew,followers)
   return crew
end