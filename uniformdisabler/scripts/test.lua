

function init()
--some of the basic positing values
  local xlistpadding= 5
  local listystart = 45
  local listwidth = 100
  local buttonystart = 85
  local buttonSeperation = 19
  
  --creation of the left(up) scroll button
  local buttonleft = ImageButton(xlistpadding,listystart,"/interface/tailor/leftbutton.png")

 
  local listxstart= buttonleft.width+xlistpadding
  local buttonRightxStart = listxstart+listwidth
  -- creation of the right(down) scroll button
  local buttonright = ImageButton(buttonRightxStart,listystart,"/interface/tailor/rightbutton.png")

  --creates the list object this is what keeps track of everything that is part of the list
  local list = PaginatedList(listxstart, listystart, listwidth, 138, 25,PortraitTextBoxCheck)
  --gets the player id value form the passed data value on interaction
  local pid = config.getParameter("passed")
  -- gets the list of crewmembers to populate the list with
  out = world.sendEntityMessage(pid,"recruits.test")
  local textsize = 14
  -- checks if promise was finished and if it was then will add each emeber of the crew to the list as an item and each item is also given all of the recruits data so it can be accesed later
  if out:finished() and out:result() then
    for _, member in pairs(out:result()) do
      local item = list:emplaceItem(member.name,member.portrait,textsize)
	  item.data=member
    end
  end
  
  greeting = Label(5, buttonleft.height+listystart+8,"Hello, my captain. What would you like the crew to wear? \nYour outfit, a sanctioned uniform, or pherhaps \nthey could wear the clothes they brought with them.", 8)
  
  GUI.add(list)
  GUI.add(greeting)
  -- adds functionality to the left and right buttons
   buttonleft.onClick = function(mouseButton) list:scroll(true) end
   buttonright.onClick  = function(mouseButton) list:scroll(false) end
  
  GUI.add(buttonleft)
  GUI.add(buttonright)

  --creation of the functional buttons that whn clicked will close the window and perform the desired function on the selcted crewmembers
  local buttonwidth = 80
  local xposUniformButtons = buttonRightxStart+ buttonright.width+ 10
  local buttonsig = TextButton(xposUniformButtons, buttonystart, buttonwidth, 16, "Original")
  buttonsig.onClick = function(mouseButton)
   callOriginal(pid,list)
   console.dismiss()
  end
  GUI.add(buttonsig)
  
  local button = TextButton(xposUniformButtons,buttonystart +buttonSeperation, buttonwidth, 16, "Uniform")
  button.onClick = function(mouseButton)
   callUniform(pid,list)
   console.dismiss()
  end
  GUI.add(button)
  -- player outfit called here becasue it does not respond well(will not run in the right order) to being called when in inside another promise function
  local outfitbutton = TextButton(xposUniformButtons,buttonystart +2*buttonSeperation, buttonwidth, 16, "Outfit")
  outfitbutton.onClick = function(mouseButton)
   callPlayerOutfit(pid,list)
   console.dismiss()
  end
  GUI.add(outfitbutton)
  GUI.setFocusedComponent(list)


 end
 
-- functions that are called whn there respective buttons are pressed
 
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
 --  sb.logWarn("%s",button)
 end

 function canvasKeyEvent(key, isKeyDown)
--   sb.logWarn("%s",key)
   GUI.keyEvent(key, isKeyDown)
 end