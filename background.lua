local images

local function load()
  images = {
    bottom = love.graphics.newImage('img/bg/bottom.png'),
    top = love.graphics.newImage('img/bg/top.png')
  }
  stg.loadImages(images)
end

local function update()

end

local function draw()
  love.graphics.draw(images.bottom, 0, 0)
  stg.mask('half', function() love.graphics.draw(images.top, stg.width / 2 - images.top:getWidth() / 2, stg.height / 2 - images.top:getHeight() / 2) end)
end

return {
  load = load,
  update = update,
  draw = draw
}
