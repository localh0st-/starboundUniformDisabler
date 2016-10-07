oldInit=Recruit.init
function Recruit:init(uuid, json)
  oldInit(self,uuid,json)
  self.original = json.original or {}
end

oldToJson=Recruit.toJson
function Recruit:toJson()
  local json = oldToJson(self)
  json.original = self.original
  return json
end
