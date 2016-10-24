require "/scripts/companions/recruitspawner.lua"

oldInit=Recruit.init
function Recruit:init(uuid, json)
  oldInit(self,uuid,json)
  self.original = json.original or deepcopy(self.storage["itemSlots"])
end

oldToJson=Recruit.toJson
function Recruit:toJson()
  local json = oldToJson(self)
  json.original = self.original
  return json
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