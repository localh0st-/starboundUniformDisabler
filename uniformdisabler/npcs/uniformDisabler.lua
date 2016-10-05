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

