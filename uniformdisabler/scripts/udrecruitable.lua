function recruitable.init()
  message.setHandler("recruit.beamOut", simpleHandler(recruitable.beamOut))
  message.setHandler("recruit.status", simpleHandler(recruitable.updateStatus))
  message.setHandler("recruit.confirmRecruitment", simpleHandler(recruitable.confirmRecruitment))
  message.setHandler("recruit.declineRecruitment", simpleHandler(recruitable.declineRecruitment))
  message.setHandler("recruit.confirmFollow", simpleHandler(recruitable.confirmFollow))
  message.setHandler("recruit.confirmUnfollow", simpleHandler(recruitable.confirmUnfollow))
  message.setHandler("recruit.confirmUnfollowBehavior", simpleHandler(recruitable.confirmUnfollowBehavior))
  message.setHandler("recruit.setUniform", simpleHandler(recruitable.setUniform))
  message.setHandler("recruit.interactBehavior", simpleHandler(setInteracted))
  message.setHandler("recruit.forcedClothes", simpleHandler(recruitable.forcedClothes))
  message.setHandler("recruit.homeClothes", simpleHandler(recruitable.homeClothes))

  local initialStatus = config.getParameter("initialStatus")
  if initialStatus then
    setCurrentStatus(initialStatus, "crew")
  end
  
  local personality = config.getParameter("personality")
  if personality then
    setPersonality(personality)
  end

  if storage.followingOwner == nil then
    storage.followingOwner = true
  end
  if storage.behaviorFollowing == nil then
    storage.behaviorFollowing = true
  end

  if recruitable.ownerUuid() or recruitable.isRecruitable() then
    recruitable.setUniform(storage.crewUniform or config.getParameter("crew.uniform"))
  end

  if recruitable.ownerUuid() then
    if not storage.beamedIn then
      status.addEphemeralEffect("beamin")
      storage.beamedIn = true
    end
    if storage.followingOwner then
      recruitable.confirmFollow(true)
    else
      recruitable.confirmUnfollow(true)
    end
  end
end





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

function recruitable.forcedClothes()
	sb.logWarn('%s',storage.original)
	sb.logWarn('%s',storage)
	if not storage.original then
	  storage.original = deepcopy(storage["itemSlots"])
	end
	recruitable.udsetUniform(nil)
	sb.logWarn('%s',storage.original)
end

function recruitable.homeClothes()
  sb.logWarn('%s',"output test")
  sb.logWarn('%s',storage)
  if storage.original then
    for slot,item in pairs(storage.original) do
	  setNpcItemSlot(slot,item)
	end
  end
  sb.logWarn('%s',storage.original)
end

function recruitable.testy()
  sb.logWarn("poduuid storage")
  sb.logWarn(storage)

end

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