local images, clock, mask

local function load()
  images = {
    bottom = love.graphics.newImage('img/bg/bottom.png'),
    top = love.graphics.newImage('img/bg/top.png')
  }
  stg.loadImages(images)
  clock = 0
  mask = 'half'
end

local function update()
  mask = 'quarter'
  local interval = 60 * 6
  if clock % interval < interval / 2 then mask = 'half' end
  clock = clock + 1
end

local function draw()
  love.graphics.draw(images.bottom, 0, 0)
  stg.mask(mask, function() love.graphics.draw(images.top, stg.width / 2 - images.top:getWidth() / 2, stg.height / 2 - images.top:getHeight() / 2) end)
end

return {
  load = load,
  update = update,
  draw = draw
}
