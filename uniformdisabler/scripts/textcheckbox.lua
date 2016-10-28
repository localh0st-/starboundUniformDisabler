
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
function PortraitTextBoxCheck:_init(x, y, width, height, text, drawable, textheight)
  RadioButton._init(self, x, y, 0)
  self.width = width
  self.height = height
  self.textheight = textheight
  
  local padding = self.textPadding
  local fontSize = textheight - padding * 2
  -- edit this to make thge image
  local portrait = Panel(0,0)
  for index,part in pairs(drawable) do
    local hello=Image(0,0,part.image,0.65)
    portrait:add(hello)
  end
  local label = Label(0, padding, text, fontSize, fontColor)
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
  local maxHeight = self.textheight - padding * 2
  local maxWidth = self.width - padding * 2
  if label.height < maxHeight then
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
