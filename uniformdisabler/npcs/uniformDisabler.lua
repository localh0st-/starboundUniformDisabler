require("/npcs/jobOffersCompat.lua")

tenant.UDsetNpcType = tenant.setNpcType
function tenant.setNpcType(npcType)
  if npc.npcType() == npcType then return end

  npc.resetLounging()
  storage.itemSlots = storage.itemSlots or {}
  -- checks for any cosmentic items
  if not storage.itemSlots.headCosmetic then
    storage.itemSlots.headCosmetic = npc.getItemSlot("headCosmetic")
  end
  if not storage.itemSlots.chestCosmetic then
    storage.itemSlots.chestCosmetic = npc.getItemSlot("chestCosmetic")
  end
  if not storage.itemSlots.legsCosmetic then
    storage.itemSlots.legsCosmetic = npc.getItemSlot("legsCosmetic")
  end
  if not storage.itemSlots.backCosmetic then
    storage.itemSlots.backCosmetic = npc.getItemSlot("backCosmetic")
  end
  -- checks for normal items if no items are found and if none are found an empty string is passed so that no items will be assigned
  if not storage.itemSlots.head or storage.itemSlots.headCosmetic then
    storage.itemSlots.head = (deepcopy(storage.itemSlots.headCosmetic) or npc.getItemSlot("head") or "")
	storage.itemSlots.headCosmetic = nil
  end
  if not storage.itemSlots.chest or storage.itemSlots.chestCosmetic then
    storage.itemSlots.chest = (deepcopy(storage.itemSlots.chestCosmetic) or npc.getItemSlot("chest") or "")
	storage.itemSlots.chestCosmetic = nil
  end
  if not storage.itemSlots.legs or storage.itemSlots.legsCosmetic then
    storage.itemSlots.legs = (deepcopy(storage.itemSlots.legsCosmetic) or npc.getItemSlot("legs") or "")
	storage.itemSlots.legsCosmetic = nil
  end
  if not storage.itemSlots.back or storage.itemSlots.backCosmetic then
    storage.itemSlots.back = (deepcopy(storage.itemSlots.backCosmetic) or npc.getItemSlot("back") or "")
	storage.itemSlots.backCosmetic = nil
  end
  


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

-- function to actually copy and not just pointers
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
