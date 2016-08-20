local function getIndexOf (tab, val)
    for index, value in ipairs (tab) do
        if value[2] == val then
            return index
        end
    end
    return false
end

function tenant.graduate()
  if storage.respawner then
    local respawnerEntityId = world.loadUniqueEntity(storage.respawner)
    if world.entityExists(respawnerEntityId) then
      if world.callScriptedEntity(respawnerEntityId, "countMonsterTenants") > 0 then
        return
      end
    end
  end

  local graduation = config.getParameter("questGenerator.graduation")

  local tailorIndex = getIndexOf(graduation.nextNpcType, 'crewmembertailor')
  if tailorIndex then table.remove(graduation.nextNpcType,tailorIndex) end

  if graduation and #graduation.nextNpcType > 0 then
    local nextNpcType = util.weightedRandom(graduation.nextNpcType)
    tenant.setNpcType(nextNpcType)
  end
end