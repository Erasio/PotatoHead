hitbox = {}

-- Position, width, height, function to execute, text to display, color (as table)
function hitbox:new(x, y, w, h, f, t, c, fixed, a)
   	local self = {}
   	self.x = x
   	self.y = y
   	self.width = w
   	self.height = h
   	self.func = f
   	self.text = t
   	self.color = c
   	self.arguments = a
      self.fixed = fixed
   	self.click = function()
      	if self.func then
         	if self.arguments then
	            self.func(unpack(self.arguments))
         	else
	            self.func()
         	end
      	end
   	end
      table.insert(buttons, self)
   	return self
end

textfield = {}

function textfield:new(x, y, t)
	self = {}
	self.x = x
	self.y = y
	self.text = t
	return self
end


