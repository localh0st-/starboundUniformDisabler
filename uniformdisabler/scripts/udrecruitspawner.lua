oldInit=Recruit.init
function Recruit:init(uuid, json)
  oldInit(self,uuid,json)
  self.customUniform = json.customUniform
  self.original = json.original
  sb.logWarn('%s',"recruit init")
  sb.logWarn('%s',self.original)
end

oldToJson=Recruit.toJson
function Recruit:toJson()
  local json = oldToJson(self)
  json.original = self.original
  return json
end
