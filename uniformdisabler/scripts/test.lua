

function init()
  local list = List(0, 0, 100, 100, 12,TextBoxCheck)
  local pid = config.getParameter("passed")
  out = world.sendEntityMessage(pid,"recruits.test")
  if out:finished() then
    for _, member in pairs(out:result()) do
      local item = list:emplaceItem(member.name)
	  item.data=member
    end
  end

  GUI.add(list)
  
  local buttonsig = TextButton(100, 25, 50, 16, "Original")
  buttonsig.onClick = function(mouseButton)
   callOriginal(pid,list)
   console.dismiss()
  end
  GUI.add(buttonsig)
  
  local button = TextButton(100, 44, 50, 16, "Uniform")
  button.onClick = function(mouseButton)
   callUniform(pid,list)
   console.dismiss()
  end
  GUI.add(button)

 end
 
function callOriginal(pid,list)
  for _, itm in pairs(list.items) do
    if itm.selected then
      local uuid = itm.data.uniqueId
	  world.sendEntityMessage(uuid,"recruit.homeClothes",pid)
	end
  end
  
end

function callUniform(pid,list)
   for _, itm in pairs(list.items) do
    if itm.selected then
      local uuid = itm.data.uniqueId
	  world.sendEntityMessage(uuid,"recruit.shipClothes",pid)
	end
  end
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