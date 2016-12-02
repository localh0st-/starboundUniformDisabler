
function Image:sizeout()
  return{self.width, self.height}
end
--adds selectable boxes
TextBoxCheck = class(TextRadioButton)

function TextBoxCheck:select()
  local siblings
  if self.parent == nil then
    siblings = GUI.components
  else
    siblings = self.parent.children
  end
  local selectedButton

  if not self.selected and self.is_a[TextBoxCheck] then
    self.selected = true
  elseif self.is_a[TextBoxCheck] and self.selected then
    self.selected = false
  end
end


PortraitTextBoxCheck = class(TextBoxCheck)
-- adds boxes with crew portraits to the left
function PortraitTextBoxCheck:_init(x, y, width, height, text, drawable, maxtextheight)
  RadioButton._init(self, x, y, 0)
  self.width = width
  self.textheight = maxtextheight
  self.height = height
  self.imageWidth = 0
  local padding = self.textPadding
  local fontSize = maxtextheight or height - padding * 2
  -- edit this to make thge image
  local portrait = Panel(0,0)
  for index,part in pairs(drawable) do
    local hello=Image(0,0,part.image,0.65)
    portrait:add(hello)
	self.imageWidth = math.max(self.imageWidth, hello.width)
  end
  local label = Label(self.imageWidth, padding, text, fontSize, fontColor)
  self.label = label
  self.portrait = portrait
  self:add(label)
  self:add(portrait)
  self.text = text
  self:addListener(
    "text",
    function(t, k, old, new)
      t.label.text = new
      t:repositionLabel()
    end
  )
  self:repositionLabel()
end


function PortraitTextBoxCheck:drawCheck(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  local checkRect = {startX + 1, startY + 1,
                     startX + w - 1, startY + h - 1}
  PtUtil.fillRect(checkRect, self.checkColor)
end

-- postion the elements of the item
function PortraitTextBoxCheck:repositionLabel()
  local label = self.label
  local text = label.text
  local padding = self.textPadding
  local imageWidth = self.imageWidth
  local maxHeight = self.height - padding * 2
  local maxWidth = self.width - padding * 2 - imageWidth
  if label.height < maxHeight and not self.textheight then
    label.fontSize = maxHeight
    label:recalculateBounds()
  end
  while label.width > maxWidth do
    label.fontSize = label.fontSize - 1
    label:recalculateBounds()
  end
  label.x = ((self.width- imageWidth) - label.width) / 2 + imageWidth
  label.y = (self.height - label.height) / 2
end


-----new list type for a paged list

PaginatedList = class(List)


--may add a page counter later but not for now

function PaginatedList:_init(x, y, width, height, itemSize, itemFactory, horizontal)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.itemSize = itemSize
  self.itemFactory = itemFactory or TextRadioButton
  self.items = {}
  self.topIndex = 1
  self.bottomIndex = 1
  self.itemCount = 0
  self.horizontal = horizontal
  self.mouseOver = false

  local borderSize = self.borderSize
  

  self:positionItems()
end

function PaginatedList:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local borderSize = self.borderSize
  local borderColor = self.borderColor
  local borderRect = {startX, startY, startX + w, startY + h}
  local rect = {startX + 1, startY + 1, startX + w - 1, startY + h - 1}
  PtUtil.drawRect(borderRect, borderColor, borderSize)
  PtUtil.fillRect(rect, self.backgroundColor)


end



function PaginatedList:emplaceItem(...)
  local width
  local height
  if self.horizontal then
    width = self.itemSize
    height = self.height - (self.borderSize * 2
                              + self.itemPadding * 2
                               + 2)
  else
    width = self.width - (self.borderSize * 2
                            + self.itemPadding * 2
                             )
    height = self.itemSize
  end
  item = self.itemFactory(0, 0, width, height, ...)
  return self:addItem(item)
end

function PaginatedList:positionItems()
  local items = self.items
  local padding = self.itemPadding
  local border = self.borderSize
  local topIndex = self.topIndex
  local itemSize = self.itemSize
  local current
  local min
  -- add to item.y to position up if on last page
  if self.horizontal then
    current = border
    min = border + padding
  else
    current = self.height - border
    min = border + padding
  end
  local past = false
  local itemCount = 0
  local possibleItemCount = 1
  --sb.logWarn("reposition")
  for i,item in ipairs(items) do
    --sb.logWarn("%s",current)
    if possibleItemCount < topIndex and not item.filtered then
	  --sb.logWarn("event 1")
      item.visible = false
      possibleItemCount = possibleItemCount + 1
    elseif past or item.filtered then
      item.visible = false
	  --sb.logWarn("event 2")
    else
	  --sb.logWarn("event 3")
      itemCount = itemCount + 1
      item.visible = nil
      if self.horizontal then
        item.y = min
        current = current + (padding + itemSize)
        item.x = current
        if current + itemSize > self.width - borderSize then
          item.visible = false
          self.bottomIndex = itemCount + topIndex - 1
          past = true
        end
      else
        item.x = min
        current = current - (padding + itemSize)
        item.y = current
        if current < border then
		  --sb.logWarn("subevent 3.1")
          item.visible = false
          self.bottomIndex = itemCount + topIndex - 1
          past = true --means its already on the list
        end
      end
    end
    item.layout = true
  end
  if not past then
    self.bottomIndex = topIndex + itemCount
  end
  --sb.logWarn("%s",self.topIndex)
end
-- this does not refer to the scrollbar scrolling but rather an independent list scrolling system
--need to difen the number the items thant can fit in the list
function PaginatedList:scroll(up)
  local totitemCount = self.itemCount
  local itemCount = math.floor((self.height-2*self.borderSize)/(self.itemSize + self.itemPadding))
  local pagetotal = math.ceil(totitemCount/itemCount)
  if up then
    self.topIndex = math.max(self.topIndex - itemCount, 1)
  else
    if true then
      self.topIndex = math.min(self.topIndex + itemCount,(pagetotal-1)*itemCount+1)
    end
  end
  self:positionItems()
end

-- new type of button

ImageButton = class(Button)

function ImageButton:_init(x, y,imagePath,scale)
  --world.logInfo("Button init with "..x..","..y..","..width..","..height..".")

  Component._init(self)
  self.mouseOver = false
  self.scale = scale
  self.x = x
  self.y = y
  self.imagePath = imagePath
  
  
  
  scale = scale or 1
  

  local imageSize = root.imageSize(imagePath)
  self.width = imageSize[1] * scale
  self.height = imageSize[2] * scale
end
-- make it draw the image mabye add a hover image or effect look at orignal button function to figure out how
function ImageButton:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]


  local imagePath = self.imagePath
  local scale = self.scale
  
  PtUtil.drawImage(imagePath, {startX, startY}, scale)
end

CustomTextButton = class(TextButton)

function CustomTextButton:_init(x, y, width, height, text, fontColor,maxtextheight)
  Button._init(self, x, y, width, height)
  local padding = self.textPadding
  local fontSize = maxtextheight or height - padding * 2
  local label = Label(0, padding, text, fontSize, fontColor)
  self.text = text
  self.maxtextheight = maxtextheight
  
  self.label = label
  self:add(label)

  self:addListener(
    "text",
    function(t, k, old, new)
      t.label.text = new
      t:repositionLabel()
    end
  )

  self:repositionLabel()
end


function CustomTextButton:repositionLabel()
  local label = self.label
  local text = label.text
  local padding = self.textPadding
  local maxtextheight = self.maxtextheight
  local maxHeight = self.height - padding * 2
  local maxWidth = self.width - padding * 2
  if label.height < maxHeight and not maxtextheight then
    label.fontSize = maxHeight
    label:recalculateBounds()
  end
  while label.width > maxWidth do
    label.fontSize = label.fontSize - 1
    label:recalculateBounds()
  end
  label.x = (self.width - label.width) / 2
  label.y = (self.height - label.height) / 2
end
