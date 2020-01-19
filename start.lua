local images, menuItems, currentMenuItem, movingMenu

local function load()
  images = {
    bg = love.graphics.newImage('img/start/bg.png'),
    tewi = love.graphics.newImage('img/start/tewi.png'),
    shark = love.graphics.newImage('img/start/shark.png'),
    title = love.graphics.newImage('img/start/title.png'),
    subTitle = love.graphics.newImage('img/start/subtitle.png'),
    peace = love.graphics.newImage('img/start/peace.png'),
    yin = love.graphics.newImage('img/start/yin.png')
  }
  stg.loadImages(images)
  menuItems = {'START', 'CONFIG', 'EXIT'}
  currentMenuItem = 1
  movingMenu = false
end

local function update()
  if controls.up() and not movingMenu then
    currentMenuItem = currentMenuItem - 1
    movingMenu = true
  elseif controls.down() and not movingMenu then
    currentMenuItem = currentMenuItem + 1
    movingMenu = true
  elseif not controls.up() and not controls.down() then movingMenu = false end
  if currentMenuItem < 1 then currentMenuItem = #menuItems
  elseif currentMenuItem > #menuItems then currentMenuItem = 1 end
  if controls.shot() then
    if currentMenuItem == 1 then loadGame()
    elseif currentMenuItem == 3 then love.event.quit() end
  end
end

local function drawBorder()
  local offset = 8
  local yOffset = 10
  local size = 32
  for i = 1, 8 do
    local img = images.peace; if i % 2 == 0 then img = images.yin end
    if i > 1 then love.graphics.draw(img, offset * 2.25 + (size + 4) * (i - 1), yOffset) end
  end
  for i = 1, 5 do
    local img = images.peace; if i % 2 == 0 then img = images.yin end
    love.graphics.draw(img, stg.width - size - offset, offset * 4 + (size + 4) * (i - 1))
  end
  for i = 1, 8 do
    local img = images.peace; if i % 2 == 0 then img = images.yin end
    love.graphics.draw(img, offset * 2.25 + (size + 4) * (i - 1), stg.height - size - yOffset)
  end
  for i = 1, 5 do
    local img = images.peace; if i % 2 == 0 then img = images.yin end
    love.graphics.draw(img, offset, offset * 4 + (size + 4) * (i - 1))
  end
  love.graphics.draw(images.peace, offset * 2.25, yOffset)
end

local function drawTitle()
  local x = stg.width / 2 - images.title:getWidth() / 2
  local y = stg.grid * 3.5
  local subX = stg.width / 2 - images.subTitle:getWidth() / 2
  local subY = y + stg.grid * 2
  love.graphics.setColor(stg.colors.black)
  love.graphics.draw(images.title, x + 1, y + 1)
  love.graphics.draw(images.subTitle, subX + 1, subY + 1)
  love.graphics.setColor(stg.colors.offWhite)
  love.graphics.draw(images.title, x, y)
  love.graphics.draw(images.subTitle, subX, subY)
  love.graphics.setColor(stg.colors.white)
end

local function drawCredits()
  local y = stg.grid * 11
  chrome.drawLabel({input = '2020 T. BODDY', y = y, align = {type = 'center'}})
end

local function drawArrow(x, y, shadow)
  local color = stg.colors.redLight
  if shadow then
    color = stg.colors.black
    x = x + 1
    y = y + 1
  end
  love.graphics.setColor(color)
  love.graphics.rectangle('fill', x, y, 1, 7)
  love.graphics.rectangle('fill', x + 1, y + 1, 1, 5)
  love.graphics.rectangle('fill', x + 2, y + 2, 1, 3)
  love.graphics.rectangle('fill', x + 3, y + 3, 1, 1)
  love.graphics.setColor(stg.colors.white)
end

local function drawMenu()
  local x = stg.width / 2 - 8 * 3
  local y = stg.height / 2 + 4
  local activeX = x - 10
  for i = 1, #menuItems do
    chrome.drawLabel({input = menuItems[i], x = x, y = y})
    if i == currentMenuItem then
      drawArrow(activeX, y, true)
      drawArrow(activeX, y)
    end
    y = y + 12
  end
end

local function draw()
  love.graphics.draw(images.bg, 0, 0)
  drawBorder()
  drawTitle()
  drawCredits()
  drawMenu()
end

return {
  load = load,
  update = update,
  draw = draw
}
