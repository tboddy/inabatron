stg = require '_stg'
controls = require 'controls'
sound = require 'sound'
background = require 'background'
player = require 'player'
stage = require 'stage'
level = require 'level'
explosion = require 'explosion'
-- start = require 'start'
chrome = require 'chrome'
start = require 'start'

local container
local tickRate = 1 / 60
local maxFrameSkip = 25

function loadGame()
	background.load()
	player.load()
	stage.load()
  explosion.load()
	chrome.load()
  stg.loaded = true
  if not stg.started then stg.started = true end
end

function love.load()
	math.randomseed(3221)
  love.window.setTitle('INABATRON: 1984')
	container = love.graphics.newCanvas(stg.width, stg.height)
	container:setFilter('nearest', 'nearest')
	love.window.setMode(stg.width * stg.scale, stg.height * stg.scale, {vsync = false})
	love.graphics.setFont(stg.font)
	controls.load()
  sound.load()
  if stg.started then loadGame()
  else start.load() end
end

function love.update()
	if controls.quit() then love.event.quit()
	elseif controls.reload() then love.event.quit('restart') end
  if stg.started then
		controls.update()
		player.update()
		stage.update()
		level.update()
		explosion.update()
	  chrome.update()
		stg.clock = stg.clock + 1
  else start.update() end
end

function love.draw()
	container:renderTo(love.graphics.clear)
	love.graphics.setCanvas({container, stencil = true})
  if stg.started then
		background.draw()
		stage.draw()
		explosion.draw()
		player.draw()
	  chrome.draw()
  else start.draw() end
	love.graphics.setCanvas()
	love.graphics.draw(container, 0, 0, 0, stg.scale, stg.scale)
end

function love.run()
  if love.load then love.load(love.arg.parseGameArguments(arg), arg) end
  if love.timer then love.timer.step() end
  local lag = 0.0
  return function()
    if love.event then
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
        if name == 'quit' then if not love.quit or not love.quit() then return a or 0 end end
        love.handlers[name](a,b,c,d,e,f)
      end
    end
    if love.timer then lag = math.min(lag + love.timer.step(), tickRate * maxFrameSkip) end
    while lag >= tickRate do
      if love.update then love.update(tickRate) end
      lag = lag - tickRate
    end
    if love.graphics and love.graphics.isActive() then
      love.graphics.origin()
      love.graphics.clear(love.graphics.getBackgroundColor())
      if love.draw then love.draw() end
      love.graphics.present()
    end
    if love.timer then love.timer.sleep(0.001) end
  end
end
