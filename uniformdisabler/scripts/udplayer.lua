
udplayerinit=init
function init()
  udplayerinit()
  message.setHandler("recruits.test", simpleHandler(test))
  message.setHandler("recruits.savetime", simpleHandler(savetime))
end

function savetime()
  recruitSpawner:markDirty()
end

function test(Iop)
  return playerCompanions.getCompanions("crew")
end