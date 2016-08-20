
local ignoreNpcs = {
  esther = true,
  frogmerchant = true,
  frogvillager = true,
  frogvisitor = true
}

local forceNpcs = {
  deadbeatscrounger = true
}


function makeRecruitable(params)
  local offerType = params.offerType
  local messages = params.messages
  local npcTeam = entity.damageTeam().team


  if isRejected() then
    local message = false
    if npcTeam ~= 1 and npcTeam ~= 0 then
     message = messages.jobOfferEnemy[npc.species()] and messages.jobOfferEnemy[npc.species()] or messages.jobOfferEnemy.generic
    end
    if ignoreNpcs[npc.npcType()] then
      message = messages.jobOfferSpecial[npc.npcType()] and messages.jobOfferSpecial[npc.npcType()] or messages.jobOfferSpecial.generic
    end
    if recruitable.isRecruitable() or recruitable.ownerUuid() then
      message = messages.jobOfferRecruitable[npc.species()] and messages.jobOfferRecruitable[npc.species()] or messages.jobOfferRecruitable.generic
    end
    if not message then
      message = messages.jobOfferSpecial.generic
    end
    npc.say(message)
    return false
  else
    return tenant.setNpcType(sb.print(offerType))
  end
end