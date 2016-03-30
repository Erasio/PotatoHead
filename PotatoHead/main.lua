function love.load()
    -- Initiate essential statics
    require "inheritance"
    require "level"

    -- Initiate everything necessary for spells
	require "checkSpells"
    require "spells.test"

    init_spells()


    --Setup Actors
    require "actors.actor_static"
    require "actors.actor_dynamic"
    require "actors.player_character"

    --Load a Level
    Level:init_level("demo")


    require "spells.super_jump"
    require "spells.double_jump"
    add_spell(DoubleJump)
    add_spell(SuperJump)

    --initial graphics setup
    love.window.setMode(1155, 650)

    collision_debugging = false
    sprites = false

    --setup camera
    require "camera"

    debugging = ""
end

function love.update(dt)
    level.world:update(dt) --this puts the world into motion

    new_linear_velocity_x = 0
    local char_x1, char_y1 = character.body:getPosition()
    local shape_x1, shape_y1, shape_x2, shape_y2, shape_x3, shape_y3, shape_x4, shape_y4 = character.shape:getPoints()
    local temp_x1, temp_y1, temp_x2, temp_y2 = 0
    for i, col in pairs(character.collisions) do
        temp_x1, temp_y1, temp_x2, temp_y2 = col:getPositions()    
    end
    if love.keyboard.isDown("a") then
        if round(char_x1 - temp_x1, 0) >= 5 or round(char_x1 - temp_x1, 0) < -1 or temp_x1 == 0 then
            new_linear_velocity_x = new_linear_velocity_x - (10000 * dt)
        end
    end
    if love.keyboard.isDown("d") then
        if not (round(char_x1 + shape_x1 - temp_x1) <= 5) or round(char_x1 + shape_x1 - temp_x1) < -1 or temp_x1 == 0 then
            new_linear_velocity_x = new_linear_velocity_x + (10000 * dt)
        end
    end
    debugging = round(char_x1 + shape_x1 - temp_x1)
    current_linear_velocity_x, current_linear_velocity_y = character.body:getLinearVelocity()
    character.body:setLinearVelocity(new_linear_velocity_x, current_linear_velocity_y)

    camera:setPosition(character.body:getPosition())
end
 

function love.draw()
    camera:set()

    love.graphics.setColor(255, 255, 255)
    for i, actor_type in pairs(level.actors) do
        for i, actor in pairs(actor_type) do
            if sprites then
                local shape_x1, shape_y1, shape_x2, shape_y2, shape_x3, shape_y3, shape_x4, shape_y4 = actor.body:getWorldPoints(actor.shape:getPoints())
                love.graphics.draw(actor.sprite, actor.quad, actor.body:getX(), actor.body:getY())
            else
                love.graphics.polygon("fill", actor.body:getWorldPoints(actor.shape:getPoints()))
            end
        end
    end

    if collision_debugging then
        love.graphics.setColor(0, 0, 200)
        for i, col in pairs(character.collisions) do
            local temp_x1, temp_y1, temp_x2, temp_y2 = col:getPositions()    
            if temp_x1 ~= nil and temp_y1 ~= nil then
                love.graphics.circle( "fill", temp_x1, temp_y1, 3) 
            end
            if temp_x2 ~= nil and temp_y2 ~= nil then
                love.graphics.circle( "fill", temp_x2, temp_y2, 3)
            end
        end

        love.graphics.setColor(200, 0, 0)
        for i, col in pairs(character.ground_col) do
            local temp_x1, temp_y1, temp_x2, temp_y2 = col:getPositions()    
            if temp_x1 ~= nil and temp_y1 ~= nil then
                love.graphics.circle( "line", temp_x1, temp_y1, 3) 
            end
            if temp_x2 ~= nil and temp_y2 ~= nil then
                love.graphics.circle( "line", temp_x2, temp_y2, 3)
            end
        end
    end

    camera:unset()

    love.graphics.setColor(0, 200, 100)
    window_x, window_y = love.window.getMode()
    love.graphics.print(spell_input, window_x / 2 - 40, window_y - 60, 0, 2.5, 2.5)
    love.graphics.print(debugging, 10, 10, 0, 2.5, 2.5)
end

function love.keypressed( key )
    if key == "up" then
        enter_spell_command("u")
    end
    if key == "down" then
        enter_spell_command("d")
    end
    if key == "left" then
        enter_spell_command("l")
    end
    if key == "right" then
        enter_spell_command("r")
    end
    if key == "w" then
        if character.is_on_ground then
            character.body:applyLinearImpulse(0, -100)
        end
    end
    if key == "q" then
        if collision_debugging then
            collision_debugging = false
        else
            collision_debugging = true
        end
    end
    if key == "e" then
        if sprites then
            sprites = false
        else
            sprites = true
        end
    end
    if key == "g" then
        Level:init_level("nico")
    end
end