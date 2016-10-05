oldInit=Recruit.init
function Recruit:init(uuid, json)
  oldInit(self,uuid,json)
  self.original = 
  { 
    items =json.storage.itemSlots,
    slots = {"legs", "chest", "back", "head"}
  }
  self.customUniform = json.customUniform
end

oldToJson=Recruit.toJson
function Recruit:toJson()
  local json = oldToJson(self)
  json.original=self.original
  json.customUniform = self.customUniform
  return json
end
