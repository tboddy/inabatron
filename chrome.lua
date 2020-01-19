local images, offset, savedScore, gameOverClock

local function load()
  images = {
    heart = love.graphics.newImage('img/chrome/heart.png'),
    heartShadow = love.graphics.newImage('img/chrome/heart-shadow.png')
  }
  stg.loadImages(images)
  offset = 4
  savedScore = false
  gameOverClock = 0
end

local function saveScore()
  print('save score')
  table.insert(stg.scoreTable, stg.currentScore)
	local scoreStr = bitser.dumps(stg.scoreTable)
	love.filesystem.write('score.lua', scoreStr)
  savedScore = true
end

local function update()
  -- if stg.gameOver
  if stg.currentScore >= stg.highScore then
    stg.highScore = stg.currentScore
    if stg.gameOver and not savedScore then saveScore() end
  end
  if stg.gameOver then gameOverClock = gameOverClock + 1 end
end

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
  local x = stg.width - offset - images.heart:getWidth() - 16
  local y = offset + 4
  love.graphics.setColor(stg.colors.black)
  love.graphics.draw(images.heart, x + 1, y + 1)
  love.graphics.setColor(stg.colors.redLight)
  love.graphics.draw(images.heart, x, y)
  love.graphics.setColor(stg.colors.red)
  love.graphics.draw(images.heartShadow, x, y)
  love.graphics.setColor(stg.colors.white)
  love.graphics.setFont(stg.fontBig)
  drawLabel({input = 'x' .. player.lives, x = x + 8, y = offset - 3})
  love.graphics.setFont(stg.font)
end

local function drawWaveBg()
  love.graphics.setColor(stg.colors.black)
  local interval = stage.waveLimit / 8
  if stg.clock < interval * 2 then love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end
  if stage.waveClock < interval then stg.mask('quarter', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end)
  elseif stage.waveClock >= interval and stage.waveClock < interval * 2 then stg.mask('half', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end)
  elseif stage.waveClock >= interval * 2 and stage.waveClock < interval * 6 then love.graphics.rectangle('fill', 0, 0, stg.width, stg.height)
  elseif stage.waveClock >= interval * 6 and stage.waveClock < interval * 7 then stg.mask('half', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end)
  elseif stage.waveClock >= interval * 7 then stg.mask('quarter', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end) end
  love.graphics.setColor(stg.colors.white)
end

local function drawWave()
  local y = stg.height - 7 - offset; if stage.inter then y = stg.height / 2 - 8 end
  if stage.inter then love.graphics.setFont(stg.fontBig) end
  drawLabel({input = 'WAVE ' .. stg.currentWave, y = y, align = {type = 'center'}})
  if stage.inter then love.graphics.setFont(stg.font) end
end

local function drawGameOver()
  love.graphics.setColor(stg.colors.black)
  local interval = stage.waveLimit / 8
  love.graphics.setColor(stg.colors.black)
  if gameOverClock < interval then stg.mask('quarter', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end)
  elseif gameOverClock >= interval and gameOverClock < interval * 2 then stg.mask('half', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end)
  elseif gameOverClock >= interval * 2 then love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end
  stg.mask('half', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end)
  love.graphics.setColor(stg.colors.white)
  local y = stg.height / 2 - 12
  love.graphics.setFont(stg.fontBig)
  drawLabel({input = 'GAME OVER', y = y - 17, align = {type = 'center'}})
  love.graphics.setFont(stg.font)
  drawLabel({input = 'YOUR SCORE:' .. processScore(stg.currentScore), y = y + 6, align = {type = 'center'}})
  if stg.currentScore >= stg.highScore then drawLabel({input = 'NEW HIGH SCORE!', y = y + 17, align = {type = 'center'}})
  else drawLabel({input = 'HIGH SCORE:' .. processScore(stg.highScore), y = y + 17, align = {type = 'center'}}) end
  drawLabel({input = 'PRESS PAUSE TO RESTART', y = y + 17 + 16, align = {type = 'center'}})
end

local function drawPaused()
  love.graphics.setColor(stg.colors.black)
  stg.mask('half', function() love.graphics.rectangle('fill', 0, 0, stg.width, stg.height) end)
  love.graphics.setColor(stg.colors.white)
  love.graphics.setFont(stg.fontBig)
  drawLabel({input = 'PAUSED', y = stg.height / 2 - 8, align = {type = 'center'}})
  love.graphics.setFont(stg.font)
end

local function draw()
  if stg.gameOver then
    drawGameOver()
  else
    if stg.currentWave > 0 and stage.inter then drawWaveBg() end
    if stg.paused then drawPaused() end
    love.graphics.setFont(stg.fontBig)
    drawLabel({input = processScore(stg.currentScore), x = offset, y = offset - 3})
    love.graphics.setFont(stg.font)
    drawLives()
    if stg.currentWave > 0 and not stg.paused then drawWave() end
  end
end

return {
  load = load,
  update = update,
  draw = draw,
  drawLabel = drawLabel,
  processScore = processScore
}
