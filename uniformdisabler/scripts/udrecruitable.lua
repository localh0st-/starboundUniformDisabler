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
	
	sb.logWarn('%s',storage["itemSlots"])
	recruitable.udsetUniform(nil)
	sb.logWarn('%s',storage["itemSlots"])
end

function recruitable.homeClothes()
  sb.logWarn('%s',storage)
  --storage.itemSlots=original does not work

end