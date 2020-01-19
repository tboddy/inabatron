local images, offset

local function load()
  images = {
    heart = love.graphics.newImage('img/chrome/heart.png'),
    heartShadow = love.graphics.newImage('img/chrome/heart-shadow.png')
  }
  stg.loadImages(images)
  offset = 4
end

local function update() end

local function processScore(input)
  local score = tostring(input)
  -- if input == 0 then score = '0' end
	for i = 1, 8 - #score do score = '0' .. score end
	return score
end

local function drawLabel(opts)
  -- opts.input = string.upper(opts.input)
  local color = stg.colors.offWhite
	local align = 'left'
	local limit = stg.width
  local x = 0
  if opts.x then x = opts.x end
  if opts.color then color = stg.colors[opts.color] end
	if opts.align then
    align = opts.align.type
    if opts.align.width then limit = opts.align.width end
  end
  if opts.big then love.graphics.setFont(stg.fontBig) end
	love.graphics.setColor(stg.colors.black)
  love.graphics.printf(opts.input, x + 1, opts.y + 1, limit, align)
	love.graphics.setColor(color)
  love.graphics.printf(opts.input, x, opts.y, limit, align)
	love.graphics.setColor(stg.colors.white)
  if opts.big then love.graphics.setFont(stg.font) end
end

local function drawLives()
  local x = stg.width - offset - images.heart:getWidth() - 16 - 2
  love.graphics.setColor(stg.colors.black)
  love.graphics.draw(images.heart, x + 1, offset + 1)
  love.graphics.setColor(stg.colors.redLight)
  love.graphics.draw(images.heart, x, offset)
  love.graphics.setColor(stg.colors.red)
  love.graphics.draw(images.heartShadow, x, offset)
  love.graphics.setColor(stg.colors.white)
  drawLabel({input = 'x' .. player.lives, x = x + 10, y = offset})
end

local function drawWave()
  local y = stg.height - 7 - offset; if stage.inter then y = stg.height / 2 - 4 end
  drawLabel({input = 'WAVE ' .. stg.currentWave, y = y, align = {type = 'center'}})
end

local function drawGameOver()
  drawLabel({input = 'GAME OVER', y = stg.height / 2 - 4, align = {type = 'center'}})
end

local function draw()
  if stg.gameOver then
    drawGameOver()
  else
    drawLabel({input = processScore(stg.currentScore), x = offset, y = offset})
    drawLives()
    if stg.currentWave > 0 then drawWave() end
  end
end

return {
  load = load,
  update = update,
  draw = draw,
  drawLabel = drawLabel
}
