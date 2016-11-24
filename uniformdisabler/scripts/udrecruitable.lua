
--creates the handlers and functions fro the crew to change their items
oldrecuitinitud=recruitable.init
function recruitable.init()
  oldrecuitinitud()
  message.setHandler("recruit.forcedClothes", simpleHandler(recruitable.forcedClothes))
  message.setHandler("recruit.homeClothes", simpleHandler(recruitable.homeClothes))
  message.setHandler("recruit.shipClothes", simpleHandler(recruitable.shipClothes))
end
-- adds the player id to the list of parameters being passed to the tailor
oldrecruitinteract=recruitable.interact
function recruitable.interact(sourceEntityId)
   oldOut = oldrecruitinteract(sourceEntityId)
  local sourceUniqueId = world.entityUniqueId(sourceEntityId)
  if world.npcType(entity.id()) == "crewmembertailor" then
    oldOut[2]["passed"] = sourceUniqueId
	  --sb.logWarn("%s","interaction changed")
	return oldOut
  else
    return oldOut
  end
end

--rewrites the opld vanila function so tha the uniform will no longer be contantly aasing
function recruitable.setUniform(uniform)
  storage.crewUniform = uniform

  local uniformSlots = config.getParameter("crew.uniformSlots")
  if not uniform then
    uniform = {
      slots = uniformSlots,
      items = config.getParameter("crew.defaultUniform")
    }
  end

  recruitable.portraitChanged = true
end

--same as set uniform function but it keeps the original colors
function recruitable.udsetClothes(uniform)
  storage.crewUniform = uniform

  local uniformSlots = config.getParameter("crew.uniformSlots")
  if not uniform then
    uniform = {
      slots = uniformSlots,
      items = config.getParameter("crew.defaultUniform")
    }
  end
  for _, slotName in pairs(uniform.slots) do
    if contains(uniformSlots, slotName) then
      setNpcItemSlot(slotName, uniform.items[slotName])
    end
  end

  recruitable.portraitChanged = true
end
-- the original setuniform function it is used to assign the uniforms when desired
function recruitable.udsetUniform(uniform)
  storage.crewUniform = uniform

  local uniformSlots = config.getParameter("crew.uniformSlots")
  if not uniform then
    uniform = {
      slots = uniformSlots,
      items = config.getParameter("crew.defaultUniform")
    }
  end
  for _, slotName in pairs(uniform.slots) do
    if contains(uniformSlots, slotName) then
      setNpcItemSlot(slotName, recruitable.dyeUniformItem(uniform.items[slotName]))
    end
  end
  recruitable.portraitChanged = true
end
-- the function that is called when the crew is told to change their clothes to a specific outfit
function recruitable.forcedClothes(pid, puni)
	if not storage.original then
	  storage.original = deepcopy(storage["itemSlots"])
	end
    if puni then
	    recruitable.udsetClothes(puni)
    end
	recruitable.portraitChanged = true
	world.sendEntityMessage(pid,"recruits.savetime")
end
-- the function that is called whn the crew is told to go back to their original clothes
function recruitable.homeClothes(pid)
  if storage.original then
    for slot,item in pairs(storage.original) do
	  setNpcItemSlot(slot,item)
	end
  end
  recruitable.portraitChanged = true
  world.sendEntityMessage(pid,"recruits.savetime")
end
--the function that is called when the crew is told to cahnge to the ship uniform
function recruitable.shipClothes(pid)
  if not storage.original then
	storage.original = deepcopy(storage["itemSlots"])
  end
  recruitable.udsetUniform(nil)
  recruitable.portraitChanged = true
  world.sendEntityMessage(pid,"recruits.savetime")
end

--keeps the orginal varaible in the npc when it is updated so that it is not discarded
udoldupdatestatus=recruitable.updateStatus

function recruitable.updateStatus(persistentEffects, damageTeam)
  local tempstorage = storage.original
  local out
  out = udoldupdatestatus(persistentEffects, damageTeam)
  out.storage.original = tempstorage
  return out

end

--a recursive copy function that gets around lua's table pionter issues
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end