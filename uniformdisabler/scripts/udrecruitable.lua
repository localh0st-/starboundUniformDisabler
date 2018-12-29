
--creates the handlers and functions for the crew to change their items
oldrecuitinitud=recruitable.init
function recruitable.init()
  oldrecuitinitud()
  message.setHandler("recruit.forcedClothes", simpleHandler(recruitable.forcedClothes))
  message.setHandler("recruit.homeClothes", simpleHandler(recruitable.homeClothes))
  message.setHandler("recruit.shipClothes", simpleHandler(recruitable.shipClothes))
  message.setHandler("recruit.getportrait", simpleHandler(recruitable.riolu))
end

-- creates a table of slots with the option of accepting ones that are modded in later
function recruitable.getUniformSlots() 
  local uniformSlots = config.getParameter("crew.uniformSlots")
  local slots ={"legs","chest","head","back","headCosmetic","chestCosmetic","legsCosmetic","backCosmetic"}
  for _,slot in pairs(slots) do
    for j,uSlot in pairs(uniformSlots) do
	  if uSlot == slot then
	    uniformSlots[j] = nil
	    break
	  end
	end
  end
  if uniformSlots then
    for _,slot in pairs(uniformSlots)do
	  table.insert(slots,slot)
	end
  end
  return slots
end

-- checks for existance of original clothing and if none exists creates the proper storage
function recruitable.originalCheck()

  if not storage.original then
    storage.original ={}
    local uniformSlots = {legs = {base = "legs",cosmetic = "legsCosmetic"}, chest = {base = "chest",cosmetic = "chestCosmetic"},back = {base = "back",cosmetic = "backCosmetic"},head = {base = "head",cosmetic = "headCosmetic"}}
	for slot,_ in pairs(uniformSlots)do
	  if not storage.original[slot] then
	    storage.original[slot] = npc.getItemSlot(uniformSlots[slot]["cosmetic"]) or npc.getItemSlot(uniformSlots[slot]["base"]) or ""
	  end
	end
  end
end

-- adds the player id to the list of parameters being passed to the tailor
oldrecruitinteract=recruitable.interact
function recruitable.interact(sourceEntityId)
  local oldOut = oldrecruitinteract(sourceEntityId)
  local sourceUniqueId = world.entityUniqueId(sourceEntityId)
  local crewType = world.npcType(entity.id())
  if crewType == "crewmembertailor" or crewType == "crewmemberalliancetailor" or crewType == "crewmemberalliancetailor-aegi" or crewType == "crewmemberaegitailor" then
    oldOut[2]["passed"] = sourceUniqueId
	  --sb.logWarn("%s","interaction changed")
	return oldOut
  else
    return oldOut
  end
end

--rewrites the old vanila function so tha the uniform will no longer be contantly asigning and renames the orignal function for later use
recruitable.udsetUniform = recruitable.setUniform
function recruitable.setUniform(uniform)




  recruitable.portraitChanged = true
end

--same as set uniform function but it keeps the original colors
function recruitable.udsetClothes(uniform)


  local uniformSlots = recruitable.getUniformSlots() 
  if not uniform then
    uniform = {
      slots = config.getParameter("crew.uniformSlots"),
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

-- the function that is called when the crew is told to change their clothes to a specific outfit
function recruitable.forcedClothes(pid, puni)
    recruitable.originalCheck()
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
  else
    recruitable.originalCheck()
  end
  recruitable.portraitChanged = true
  world.sendEntityMessage(pid,"recruits.savetime")
end
--the function that is called when the crew is told to cahnge to the ship uniform
function recruitable.shipClothes(pid)
  recruitable.originalCheck()
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

function recruitable.riolu()
	return world.entityPortrait(entity.id(),"full")
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