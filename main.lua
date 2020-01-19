bitser = require 'bitser'
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

local function loadScore()
	print('loading score')
	local scoreData = love.filesystem.read('score.lua')
	if scoreData then
		stg.scoreTable = bitser.loads(scoreData)
		table.sort(stg.scoreTable, function(a, b)
		 return a > b
		end)
		if(stg.scoreTable[1]) then stg.highScore = stg.scoreTable[1] end
	else stg.scoreTable = {} end
end

function love.load()
	math.randomseed(3221)
  love.window.setTitle('INABATRON: 1984')
	container = love.graphics.newCanvas(stg.width, stg.height)
	container:setFilter('nearest', 'nearest')
	love.window.setMode(stg.width * stg.scale, stg.height * stg.scale, {vsync = false})
	love.graphics.setFont(stg.font)
	loadScore()
	controls.load()
  sound.load()
  if stg.started then loadGame()
  else start.load() end
end

local pausing = false

function love.update()
  if stg.started then
		if controls.quit() and not pausing then
			if stg.gameOver then love.event.quit('restart') end
			if stg.paused then stg.paused = false else stg.paused = true end
			pausing = true
		elseif not controls.quit() then pausing = false end
		if controls.reload() then love.event.quit('restart') end
		controls.update()
		if not stg.paused then
			player.update()
			stage.update()
			level.update()
			explosion.update()
		end
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
	local windowX = 0
	local fullscreenWidth, fullscreenHeight = love.window.getDesktopDimensions()
	if stg.fullscreen then windowX = fullscreenWidth / 2 - stg.width / 2 * stg.scale end
	love.graphics.draw(container, windowX, 0, 0, stg.scale, stg.scale)
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
