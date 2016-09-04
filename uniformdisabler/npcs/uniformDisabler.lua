require("/npcs/jobOffersCompat.lua")
require("/npcs/noTailor.lua")
function tenant.setNpcType(npcType)
  if npc.npcType() == npcType then return end

  npc.resetLounging()
  storage.itemSlots = storage.itemSlots or {}
  if not storage.itemSlots.headCosmetic and not storage.itemSlots.headCosmetic then
    storage.itemSlots.headCosmetic = npc.getItemSlot("headCosmetic")
  end
  if not storage.itemSlots.head then
    storage.itemSlots.head = npc.getItemSlot("head")
  end
  
  storage.itemSlots.head = (npc.getItemSlot("head") or "")
  storage.itemSlots.chest = (npc.getItemSlot("chest") or "")
  storage.itemSlots.legs = (npc.getItemSlot("legs") or "")
  storage.itemSlots.back = (npc.getItemSlot("back") or "")
  storage.original = {}
  storage.original = storage.itemSlots

  storage.itemSlots.primary = nil
  storage.itemSlots.alt = nil

  local newUniqueId = sb.makeUuid()
  local newEntityId = world.spawnNpc(entity.position(), npc.species(), npcType, npc.level(), npc.seed(), {
    identity = npc.humanoidIdentity(),
    scriptConfig = {
        personality = personality(),
        initialStorage = preservedStorage(),
      	uniqueId = newUniqueId
      }
  })

  if storage.respawner then
  assert(newUniqueId and newEntityId)
  world.callScriptedEntity(newEntityId, "tenant.setHome", storage.homePosition, storage.homeBoundary, storage.respawner, true)

  local spawnerId = world.loadUniqueEntity(storage.respawner)
  assert(spawnerId and world.entityExists(spawnerId))
  world.callScriptedEntity(spawnerId, "replaceTenant", entity.uniqueId(), {
      uniqueId = newUniqueId,
      type = npcType
    })
  end
  tenant.despawn(false)

  local function usingJobOffers(module)
    require(module)
  end
  jobOffersPresent = pcall(usingJobOffers,"/npcs/jobOffers.lua")

  if(jobOffersPresent) then
    return newUniqueId
  end
end

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
  message.setHandler("recruit.setItemMobius", simpleHandler(recruitable.setItemMobius))

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

function recruitable.dyeUniformItem(item)
  return item
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

function recruitable.setItemMobius(clothes)
	if not clothes then
		storage.itemSlots = storage.original
	else
		storage.itemSlots = clothes
	end
end