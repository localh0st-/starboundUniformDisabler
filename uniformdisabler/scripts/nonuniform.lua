

function init()
--some of the basic positioning values
-- notes: changes needed penguin ui now needs to take in a canvas name
  local xlistpadding= 5
  local listystart = 45
  local listwidth = 100
  local buttonystart = 80
  local buttonSeperation = 26
  local buttonwidth = 100
  local buttontextheight = 14
  local buttonheight = 20
  NUmaxtextsize = 12
  NUCanvas = widget.bindCanvas("scriptCanvas")
  --creation of the left(up) scroll button
  local buttonleft = ImageButton(NUCanvas, xlistpadding,listystart,"/interface/tailor/leftbutton.png")
  widget.focus("scriptCanvas")
 
  local listxstart= buttonleft.width+xlistpadding
  local buttonRightxStart = listxstart+listwidth
  -- creation of the right(down) scroll button
  local buttonright = ImageButton(NUCanvas, buttonRightxStart,listystart,"/interface/tailor/rightbutton.png")

  --creates the list object this is what keeps track of everything that is part of the list
  list = PaginatedList(NUCanvas,listxstart, listystart, listwidth, 138, 25,PortraitTextBoxCheck) -- this cannot be local or else it cannot be accesed in update
  --gets the player id value form the passed data value on interaction
  local pid = config.getParameter("passed")
  -- gets the list of crewmembers to populate the list with
  out = world.sendEntityMessage(pid,"recruits.test")
  -- checks if promise was finished and if it was then will add each emeber of the crew to the list as an item and each item is also given all of the recruits data so it can be accesed later

 
  
  greeting = Label(NUCanvas, xlistpadding+7, buttonleft.height+listystart+8,"Hello, my captain. What would you like the crew to wear? \nYour outfit, a sanctioned uniform, or pherhaps \nthey could wear the clothes they brought with them.", 8)
  
  GUI.add(list)
  GUI.add(greeting)
  -- adds functionality to the left and right buttons
   buttonleft.onClick = function(mouseButton) list:scroll(true) end
   buttonright.onClick  = function(mouseButton) list:scroll(false) end
  
  GUI.add(buttonleft)
  GUI.add(buttonright)

  --creation of the functional buttons that whn clicked will close the window and perform the desired function on the selcted crewmembers

  local xposUniformButtons = buttonRightxStart+ buttonright.width+ 10
  local buttonsig = CustomTextButton(NUCanvas, xposUniformButtons, buttonystart, buttonwidth, buttonheight, "Original",nil,buttontextheight)
  buttonsig.onClick = function(mouseButton)
   callOriginal(pid,list)
   pane.dismiss()
  end
  GUI.add(buttonsig)
  
  local button = CustomTextButton(NUCanvas, xposUniformButtons,buttonystart +buttonSeperation, buttonwidth, buttonheight, "Uniform",nil,buttontextheight)
  button.onClick = function(mouseButton)
   callUniform(pid,list)
   pane.dismiss()
  end
  GUI.add(button)
  -- player outfit called here becasue it does not respond well(will not run in the right order) to being called when in inside another promise function
  local outfitbutton = CustomTextButton(NUCanvas, xposUniformButtons,buttonystart +2*buttonSeperation, buttonwidth, buttonheight, "Outfit",nil,buttontextheight)
  outfitbutton.onClick = function(mouseButton)
   callPlayerOutfit(pid,list)
   pane.dismiss()
  end
  GUI.add(outfitbutton)
  GUI.setFocusedComponent(list)

  getportraits(list)
  
  
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

function getportraits(list)
  NUCrew = out:result()
  for Index, member in pairs(NUCrew) do
    NUCrew[Index].portrait = world.sendEntityMessage(member.uniqueId,"recruit.getportrait")
  end
end

--adding crew members in the update becaue I cannot get an up to date picture of their current outfit in init before it completes running
--a local variable in init will not be transfered to update and a local vaiable in update will not carry over to the next update so update can only access non local varaibles
-- the crew needs to be gotten int the update not init it is too hartd to check for completion from init function and then added in the update, ideally will only run once 
 function update(dt)
	if not UNSC then
	  UNSC = true
	  for Index, member in pairs(NUCrew) do
	    if member.portrait:finished() and not member.added then
		  if member.portrait:result() then
		    local item = list:emplaceItem(member.name, member.portrait:result(), NUmaxtextsize)
			item.data=member
		  end
		  NUCrew[Index] = nil  -- so it will not run this case again once added to the list
		else
		  UNSC = false
		end
	  end
	end
   GUI.step(NUCanvas,dt)
 end

 function canvasClickEvent(position, button, pressed)
   GUI.clickEvent(position, button, pressed)
 end

 function canvasKeyEvent(key, isKeyDown)
   GUI.keyEvent(key, isKeyDown)
 end