require("/npcs/jobOffersCompat.lua")

tenant.UDsetNpcType = tenant.setNpcType
function tenant.setNpcType(npcType)
  if npc.npcType() == npcType then return end

  npc.resetLounging()
  storage.itemSlots = storage.itemSlots or {}
  if not storage.itemSlots.headCosmetic and not storage.itemSlots.headCosmetic then
    storage.itemSlots.headCosmetic = npc.getItemSlot("headCosmetic")
  end
  if not storage.itemSlots.head then
    storage.itemSlots.head = (npc.getItemSlot("head") or "")
  end
  
  
  storage.itemSlots.chest = (npc.getItemSlot("chest") or "")
  storage.itemSlots.legs = (npc.getItemSlot("legs") or "")
  storage.itemSlots.back = (npc.getItemSlot("back") or "")


  storage.original=storage.itemSlots

  tenant.UDsetNpcType(npcType) 

  local function usingJobOffers(module)
    require(module)
  end
  jobOffersPresent = pcall(usingJobOffers,"/npcs/jobOffers.lua")

  if(jobOffersPresent) then
    return newUniqueId
  end
end

