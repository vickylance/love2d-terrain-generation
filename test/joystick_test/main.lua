function love.load()
    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

    position = {x = 400, y = 300}
    speed = 300
end



function love.update(dt)
    if not joystick then
        return
    end

    local deadZone = 0.4
    -- joystick X for player controlling
    if joystick:getGamepadAxis('leftx') < -deadZone or joystick:getGamepadAxis('rightx') < -deadZone then
        position.x = position.x - speed * dt
    end
    if joystick:getGamepadAxis('leftx') > deadZone or joystick:getGamepadAxis('rightx') > deadZone then
        position.x = position.x + speed * dt
    end

    -- joystick Y for player shooting
    if joystick:getGamepadAxis('lefty') < -deadZone or joystick:getGamepadAxis('righty') < -deadZone then
        position.y = position.y - speed * dt
    end
    if joystick:getGamepadAxis('lefty') > deadZone or joystick:getGamepadAxis('righty') > deadZone then
        position.y = position.y + speed * dt
    end

    if joystick:isGamepadDown('dpleft') then
        position.x = position.x - speed * dt
    elseif joystick:isGamepadDown('dpright') then
        position.x = position.x + speed * dt
    end

    if joystick:isGamepadDown('dpup') then
        position.y = position.y - speed * dt
    elseif joystick:isGamepadDown('dpdown') then
        position.y = position.y + speed * dt
    end
end

function love.draw()
    love.graphics.circle('fill', position.x, position.y, 50)
end
