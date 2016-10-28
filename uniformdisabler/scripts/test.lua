

function init()
  local list = List(0, 0, 100, 150, 25,PortraitTextBoxCheck)
  local pid = config.getParameter("passed")
  out = world.sendEntityMessage(pid,"recruits.test")
  local textsize = 14
  if out:finished() and out:result() then
    for _, member in pairs(out:result()) do
      local item = list:emplaceItem(member.name,member.portrait,textsize)
	  item.data=member
    end
  end

  GUI.add(list)
  sb.logWarn("%s",GUI.mouseState)
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
  
  local outfitbutton = TextButton(100, 63, 50, 16, "Outfit")
  outfitbutton.onClick = function(mouseButton)
   callPlayerOutfit(pid,list)
   console.dismiss()
  end
  GUI.add(outfitbutton)
  GUI.setFocusedComponent(list)

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

function callPlayerOutfit(pid,list)
   puni = world.sendEntityMessage(pid,"player.getPlayerUniform")
   for _, itm in pairs(list.items) do
    if itm.selected then
      local uuid = itm.data.uniqueId
	  world.sendEntityMessage(uuid,"recruit.forcedClothes",pid,puni:result())
	end
  end
end

 function update(dt)
   GUI.step(dt)
 end

 function canvasClickEvent(position, button, pressed)
   GUI.clickEvent(position, button, pressed)
   sb.logWarn("%s","I run")
 end

 function canvasKeyEvent(key, isKeyDown)
   sb.logWarn("%s",key)
   GUI.keyEvent(key, isKeyDown)
 end