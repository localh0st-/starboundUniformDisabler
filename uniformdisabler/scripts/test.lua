

function init()
 --  local button = TextButton(60, 25, 50, 16, "Close")
--   button.onClick = function(mouseButton)
--     console.dismiss()
 --  end
--   GUI.add(button)
  --local myMinions=playerCompanions.getCompanions("crew")
  local list = List(0, 0, 100, 100, 12)
  sb.logWarn("%s",config.getParameter("passed"))
  out = world.sendEntityMessage(config.getParameter("passed"),"recruits.test","in")
  if out:finished() then
    for _, member in pairs(out:result()) do
      local item = list:emplaceItem(member.name)
      item:addListener("selected", function() sb.logWarn("i am "..member.name) end)
    end
  end
  GUI.add(list)
 end

 function update(dt)
   GUI.step(dt)
 end

 function canvasClickEvent(position, button, pressed)
   GUI.clickEvent(position, button, pressed)
 end

 function canvasKeyEvent(key, isKeyDown)
   GUI.keyEvent(key, isKeyDown)
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