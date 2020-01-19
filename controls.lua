local joystick = false

local function load()
  local joysticks = love.joystick.getJoysticks()
  for i = 1, #joysticks do if i == 1 then joystick = joysticks[i] end end
  local dirTable = {'left', 'right', 'up', 'down', 'w', 's', 'a', 'd'}
  for i = 1, #dirTable do controls[dirTable[i]] = function()
    local isPressed = love.keyboard.isDown(dirTable[i])
    if joystick then
      local axis1, axis2, axis3, axis4, axis5 = joystick:getAxes(joystick)
      local leftX = math.floor(axis1 * 10)
      local leftY = math.floor(axis2 * 10)
      local rightX = math.floor(axis4 * 10)
      local rightY = math.floor(axis5 * 10)
      if dirTable[i] == 'a' and leftX <= -5 then isPressed = true
      elseif dirTable[i] == 'd' and leftX >= 5 then isPressed = true end
      if dirTable[i] == 'w' and leftY <= -5 then isPressed = true
      elseif dirTable[i] == 's' and leftY >= 5 then isPressed = true end
      if dirTable[i] == 'left' and rightX <= -5 then isPressed = true
      elseif dirTable[i] == 'right' and rightX >= 5 then isPressed = true end
      if dirTable[i] == 'up' and rightY <= -5 then isPressed = true
      elseif dirTable[i] == 'down' and rightY >= 5 then isPressed = true end
    end
    return isPressed
  end end
end

local function shot()
  return love.keyboard.isDown('z') or (joystick and joystick:isDown(1))
end

local function focus()
  return love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift') or (joystick and joystick:isDown(2))
end

local function update()
  -- if joystick then
  --   local axis1, axis2, axis3, axis4, axis5 = joystick:getAxes(joystick)
  --   local rightX = math.floor(axis4 * 10)
  --   local rightY = math.floor(axis5 * 10)
  --   print(rightX, rightY)
  -- end
end

local function reload()
  return love.keyboard.isDown('r')
end

local function quit()
  return love.keyboard.isDown('escape')
end

return {
  load = load,
  shot = shot,
  focus = focus,
  update = update,
  reload = reload,
  quit = quit
}
