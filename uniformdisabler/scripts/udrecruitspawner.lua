oldInit=Recruit.init
function Recruit:init(uuid, json)
  oldInit(self,uuid,json)
  self.original = json.original or {"im original"}
  sb.logWarn('%s',"recruit init")
  sb.logWarn('%s',json.original)
  sb.logWarn('%s',json.storage)
end

oldToJson=Recruit.toJson
function Recruit:toJson()
  local json = oldToJson(self)
  json.original = self.original
--  sb.logWarn('%s',"saved to json")
--  sb.logWarn('%s',self.storage)
--  sb.logWarn('%s',self.original)
  return json
end
