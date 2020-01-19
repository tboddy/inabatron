local joystick = false

local function load()
  local joysticks = love.joystick.getJoysticks()
  for i = 1, #joysticks do if i == 1 then joystick = joysticks[i] end end
  local dirTable = {'left', 'right', 'up', 'down', 'w', 's', 'a', 'd'}
  for i = 1, #dirTable do controls[dirTable[i]] = function()
    local isPressed = love.keyboard.isDown(dirTable[i])
    if joystick then
      local axis1, axis2, axis3, axis4, axis5, axis6 = joystick:getAxes()
      local hat1 = joystick:getHat(1)
      local leftX = math.floor(axis1 * 10)
      local leftY = math.floor(axis2 * 10)
      local rightX = math.floor(axis4 * 10)
      local rightY = math.floor(axis5 * 10)
      if hat1 then
        if hat1 == 'l' or hat1 == 'lu' or hat1 == 'ld' then leftX = -10 end
        if hat1 == 'r' or hat1 == 'ru' or hat1 == 'rd' then leftX = 10 end
        if hat1 == 'u' or hat1 == 'lu' or hat1 == 'ru' then leftY = -10 end
        if hat1 == 'd' or hat1 == 'ld' or hat1 == 'rd' then leftY = 10 end
      end
      if dirTable[i] == 'a' and (leftX <= -5) then isPressed = true
      elseif dirTable[i] == 'd' and (leftX >= 5) then isPressed = true end
      if dirTable[i] == 'w' and (leftY <= -5) then isPressed = true
      elseif dirTable[i] == 's' and (leftY >= 5) then isPressed = true end
      if dirTable[i] == 'left' and (rightX <= -5 or (stg.started and joystick:isDown(3))) then isPressed = true
      elseif dirTable[i] == 'right' and (rightX >= 5 or (stg.started and joystick:isDown(2))) then isPressed = true end
      if dirTable[i] == 'up' and (rightY <= -5 or (stg.started and joystick:isDown(4))) then isPressed = true
      elseif dirTable[i] == 'down' and (rightY >= 5 or (stg.started and joystick:isDown(1))) then isPressed = true end
    end
    return isPressed
  end end
end

local function shot()
  -- or (joystick and (joystick:isDown(1) or joystick:isDown(2))
  return love.keyboard.isDown('z') or love.keyboard.isDown('return') or (joystick and not stg.started and (joystick:isDown(1) or joystick:isDown(2)))
end

local function focus()
  --  or (joystick and (joystick:isDown(3) or joystick:isDown(4))
  return love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')
end

local function update()
  -- if joystick then
    -- print(joystick:isDown(7))
  -- end
end

local function reload()
  return love.keyboard.isDown('r') or (joystick and joystick:isDown(7))
end

local function quit()
  return love.keyboard.isDown('escape') or (joystick and joystick:isDown(8))
end

return {
  load = load,
  shot = shot,
  focus = focus,
  update = update,
  reload = reload,
  quit = quit
}
