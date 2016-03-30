function love.load()
	require "levelEditor.level"
	require "levelEditor.inheritance"
	require "levelEditor.actor_static"
    require "levelEditor.actor_dynamic"
    require "levelEditor.actor_meta"
    require "levelEditor.ui_elements"
    require "levelEditor.camera"

	buttons = {}
   	hitbox:new(690, 560, 100, 30, save_map, "Save Map", {0, 0, 200}, true)
   	hitbox:new(580, 560, 100, 30, create_block, "Create Block", {0, 0, 200}, true)
   	
   	text_input = ""
   	last_x, last_y = 0
   	selected_actor = nil
   	extend_mode = false
end

function love.update(dt)
	mouse_x, mouse_y = love.mouse.getPosition()
	local xdiff, ydiff = 0
	if last_x ~= nil and last_y ~= nil then
		xdiff = mouse_x - last_x
		ydiff = mouse_y - last_y
	end
	if love.mouse.isDown(2) then
		if selected_actor == nil or love.mouse.isDown(1) then			
			camera:move(-xdiff * camera.scaleX, -ydiff * camera.scaleY)
		else
			local actor_x, actor_y = selected_actor.body:getPosition()
			selected_actor.body:setPosition(round(actor_x + xdiff * camera.scaleX, 0), round(actor_y + ydiff * camera.scaleY, 0))
			selected_actor:set_hitbox()
		end
	elseif love.mouse.isDown(1) then
		if selected_actor ~= nil and extend_mode then
			selected_actor:extend(xdiff * camera.scaleX, ydiff * camera.scaleY)
		end
	end
	last_x = mouse_x
	last_y = mouse_y
end

function love.draw()
	camera:set()

	if level ~= nil then
		for i, actor_type in pairs(level.actors) do
        	for j, actor in pairs(actor_type) do
        		if not actor.body:isDestroyed() then
        			love.graphics.polygon("fill", actor.body:getWorldPoints(actor.shape:getPoints()))
        		else
        			table.remove(level.actors[i], j)
        		end
        	end
        end
    end

    for i, button in pairs(buttons) do
    	if not button.fixed then
			love.graphics.setColor(button.color)
			love.graphics.polygon("fill", button.x, button.y, button.x, button.y + button.height, button.x + button.width, button.y + button.height, button.x + button.width, button.y)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print(button.text, button.x + 5, button.y + 5)
		end
	end

    camera:unset()

	for i, button in pairs(buttons) do
		if button.fixed then
			love.graphics.setColor(button.color)
			love.graphics.polygon("fill", button.x, button.y, button.x, button.y + button.height, button.x + button.width, button.y + button.height, button.x + button.width, button.y)
			love.graphics.setColor(255, 255, 255)
			love.graphics.print(button.text, button.x + 5, button.y + 5)
		end
	end

	love.graphics.print("Text Input:\"" .. text_input .. "\"", 0, 0)

	if selected_actor ~= nil then
		local actor_x, actor_y = selected_actor.body:getPosition()
		love.graphics.print("Location: " .. round(actor_x, 0) .. " / " .. round(actor_y,0), 670, 10)
		local x1, y1, x2, y2, x3, y3, x4, y4 = selected_actor.shape:getPoints()
		love.graphics.print("Size: " .. round(x2 - x4) .. " / " .. round(y2 - y4), 670, 30)
	end
end

function love.textinput(t)
	text_input = text_input .. t
end

function love.mousepressed(x, y, button)
   	if button == 1 then
	   	if not love.mouse.isDown(2) then
	   		local clicked = false
	   		local once = true
	   		local hitboxes_found = {}
	   		local temp_x, temp_y = 0
	      	for i, v in pairs(buttons) do
	      		if v.fixed then
	      			temp_x = x
	      			temp_y = y
	      		else
	         		temp_x = (x  * camera.scaleX) + camera.x
					temp_y = (y  * camera.scaleY) + camera.y
		         	if once then
	    	     		once = false
	    	     	end
	         	end
	         	print(temp_x, temp_y, v.x, v.y, v.x + v.width, v.y + v.height)
	         	if temp_x >= v.x and temp_y >= v.y and temp_x < v.x+v.width and temp_y < v.y+v.height then
	         		print("Hit!")
	         		table.insert(hitboxes_found, v)
		           	clicked = true
	         	end
	      	end
	      	if clicked then
	      		print("Hitboxes found: ", #hitboxes_found)
	      		hitboxes_found[#hitboxes_found].click()
	      	end
	      	if not clicked then
	      		if selected_actor ~= nil then
	      			selected_actor.set_unactive(selected_actor)
	      		end
	      	end
	    end
   	end
end

function love.mousereleased(x, y, button)
	if button == 2 and selected_actor ~= nil then
		selected_actor:set_hitbox()
	elseif button == 1 and extend_mode then
		extend_mode = false
		selected_actor.extend_direction = nil
	end
end


function love.wheelmoved( x, y )
	camera:setScale(camera.scaleX + (-y/20), camera.scaleY + (-y/20))
end

function love.keypressed( key )
	if key == "backspace" then
		text_input = ""
	elseif key == "return" then
		if selected_actor ~= nil then
			selected_actor = nil
		elseif text_input ~= "" and level == nil then
			open_map()
		end
	end
	if key == "lctrl" then
		camera:setScale(1, 1)
	end
	if key == "delete" then
		if selected_actor ~= nil then
			selected_actor:destroy()
			selected_actor = nil
		end
	end
end


function open_map()
	level = nil
	print("Open level: " .. text_input)
 	Level:init_level(text_input)
 	camera:setPosition(0, 0)
 	camera:setScale(1, 1)
 	text_input = ""
end

function save_map()
	if level ~= nil then
		file = io.open(level.map .. ".map", "w")
		for i, actor_type in pairs(level.actors) do
        	for j, actor in pairs(actor_type) do
        		file:write(i .. ",")
        		local actor_x, actor_y = actor.body:getPosition()
        		file:write(actor_x .. "," .. actor_y .. ",")
        		local x1, y1, x2, y2, x3, y3, x4, y4 = actor.shape:getPoints()
        		print(i)
        		file:write(x1 .. "," .. y1 .. "," .. x2 .. "," .. y2 .. "," .. x3 .. "," .. y3 .. "," .. x4 .. "," .. y4 .. ",")
        		file:write("\n")
        	end
        end
        file:close()
        print(level.map .. ".map saved")
    end
end

function create_block()
	local actor_shape = love.physics.newPolygonShape(100, 0, 100, 100, 0, 100, 0, 0)
    local actor_quad = love.graphics.newQuad(0, 0, 100, 100, level.default_sprite:getDimensions())
    local window_x, window_y = love.window.getMode()
    ActorStatic.create(level, camera.x +  camera.scaleX * ((window_x / 2) - 50) , camera.y + camera.scaleY * ((window_y / 2) - 50), actor_shape, level.default_sprite, actor_quad)
end

