oldrecuitinitud=recruitable.init
function recruitable.init()
  oldrecuitinitud()
  message.setHandler("recruit.forcedClothes", simpleHandler(recruitable.forcedClothes))
  message.setHandler("recruit.homeClothes", simpleHandler(recruitable.homeClothes))
end





function recruitable.setUniform(uniform)
  storage.crewUniform = uniform

  local uniformSlots = config.getParameter("crew.uniformSlots")
  if not uniform then
    uniform = {
      slots = uniformSlots,
      items = config.getParameter("crew.defaultUniform")
    }
  end

  recruitable.portraitChanged = true
end

function recruitable.udsetUniform(uniform)
  storage.crewUniform = uniform

  local uniformSlots = config.getParameter("crew.uniformSlots")
  if not uniform then
    uniform = {
      slots = uniformSlots,
      items = config.getParameter("crew.defaultUniform")
    }
  end
  for _, slotName in pairs(uniform.slots) do
    if contains(uniformSlots, slotName) then
      setNpcItemSlot(slotName, recruitable.dyeUniformItem(uniform.items[slotName]))
    end
  end

  recruitable.portraitChanged = true
end

function recruitable.forcedClothes(puni)
	if not storage.original then
	  storage.original = deepcopy(storage["itemSlots"])
	end
	recruitable.udsetUniform(puni)
end

function recruitable.homeClothes()
  if storage.original then
    for slot,item in pairs(storage.original) do
	  setNpcItemSlot(slot,item)
	end
  end
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