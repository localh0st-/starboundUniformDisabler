oldInit=Recruit.init
function Recruit:init(uuid, json)
  oldInit(self,uuid,json)
  if not json.original then
	  self.original = json.storage.itemSlots
  else
	self.original = json.original
  end
  self.customUniform = json.customUniform

end

oldToJson=Recruit.toJson
function Recruit:toJson()
  local json = oldToJson(self)
  json.original = self.original
  json.customUniform = self.customUniform
  return json
end
