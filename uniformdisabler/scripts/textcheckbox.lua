
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