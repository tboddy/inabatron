local images, x, y, flip, canShoot, shotClock, lives, bullets, bulletSpeed, bulletAngle, initX, initY, invulnerableLimit

local function load()
  images = {
    idle = love.graphics.newImage('img/player/idle.png'),
    idleOver = love.graphics.newImage('img/player/idleover.png'),
    bullet = love.graphics.newImage('img/player/bullet.png')
  }
  stg.loadImages(images)
  initX = stg.width / 2
  initY = stg.height / 2
  x = initX
  y = initY
  flip = 1
  canShoot = true
  shotClock = 0
  lives = 2
  bullets = {}
  for i = 1, 64 do bullets[i] = {} end
  bulletSpeed = images.bullet:getWidth()
  bulletAngle = 0
  invulnerableLimit = 60 * 2.5
end

local function updateMove()
  local speed = 2
  local xSpeed = 0; if controls.a() then xSpeed = -1 elseif controls.d() then xSpeed = 1 end
  local ySpeed = 0; if controls.w() then ySpeed = -1 elseif controls.s() then ySpeed = 1 end
  local fSpeed = speed / math.sqrt(math.max(xSpeed + ySpeed, 1))
  x = x + fSpeed * xSpeed
  y = y + fSpeed * ySpeed
  if controls.a() then flip = -1
  elseif controls.d() then flip = 1 end
  if stage.inter then
    x = initX
    y = initY
  end
  player.x = x
  player.y = y
  if x < images.idle:getWidth() / 2 then x = images.idle:getWidth() / 2 elseif x > stg.width - images.idle:getWidth() / 2 then x = stg.width - images.idle:getWidth() / 2 end
  if y < images.idle:getHeight() / 2 then y = images.idle:getHeight() / 2 elseif y > stg.height - images.idle:getHeight() / 2 then y = stg.height - images.idle:getHeight() / 2 end
  for i = 1, #stage.enemies do
    if stage.enemies[i].active and stage.enemies[i].seen then
      if stage.enemies[i].type == 'rabbit' and math.sqrt((stage.enemies[i].x - x) * (stage.enemies[i].x - x) + (stage.enemies[i].y - y) * (stage.enemies[i].y - y)) < stage.enemies[i].height / 2 + images.idle:getHeight() / 2 then
        stage.enemies[i].flags.caught = true
        sound.playSfx('rabbit')
      end
    end
  end
end

local function spawnBullet()
	local diff = math.pi / 9
  local bullet = bullets[stg.getIndex(bullets)]
  local offset = 4
	bullet.active = true
  bullet.angle = bulletAngle
	bullet.x = x + math.cos(bullet.angle) * offset
	bullet.y = y + math.sin(bullet.angle) * offset
  local size = images.bullet:getHeight() / 2; if bullet.double then size = size * 2 end
  local drunk = .025
  bullet.angle = bullet.angle - drunk + drunk * 2 * math.random()
  sound.playSfx('playershot')
end

local function updateBullet(bullet)
	bullet.x = bullet.x + math.cos(bullet.angle) * bulletSpeed
	bullet.y = bullet.y + math.sin(bullet.angle) * bulletSpeed
	if bullet.x < -images.bullet:getWidth() * 2 or bullet.x > stg.width + images.bullet:getWidth() * 2 or bullet.y < -images.bullet:getHeight() * 2 or bullet.y > stg.height + images.bullet:getHeight() * 2 then bullet.active = false
  else
    local kill = false
    local size = images.bullet:getWidth() / 2
    for i = 1, #stage.enemies do
      if stage.enemies[i].active and stage.enemies[i].seen and stage.enemies[i].type ~= 'rabbit' then
        if math.sqrt((stage.enemies[i].x - bullet.x) * (stage.enemies[i].x - bullet.x) + (stage.enemies[i].y - bullet.y) * (stage.enemies[i].y - bullet.y)) < stage.enemies[i].height / 2 + size then
          if stage.enemies[i].type == 'amikiri' then
            stage.enemies[i].flags.hit = true
            kill = true
          else
            stage.enemies[i].health = stage.enemies[i].health - 1
            kill = true
          end
        end
      end
    end
    if kill then
      explosion.spawn({x = bullet.x, y = bullet.y, type = 'gray'})
      if math.random() < .5 then sound.playSfx('explosion1') else sound.playSfx('explosion2') end
      bullet.active = false
    end
    if kill then bullet.active = false end
  end
end

local function updateShot()
  local shooting = false; if controls.up() or controls.left() or controls.right() or controls.down() then shooting = true end
  if stage.inter then canShoot = false end
	if shooting and canShoot then
    local canLook = true
    if controls.left() then
      bulletAngle = math.pi
      if controls.up() then
        bulletAngle = bulletAngle + math.pi / 4
        canLook = false
      end
    elseif controls.right() then
      bulletAngle = 0
      if controls.down() then
        bulletAngle = bulletAngle + math.pi / 4
        canLook = false
      end
    end
    if controls.up() and canLook then
      bulletAngle = math.pi * 1.5
      if controls.right() then bulletAngle = bulletAngle + math.pi / 4 end
    elseif controls.down() and canLook then
      bulletAngle = math.pi / 2
      if controls.left() then bulletAngle = bulletAngle + math.pi / 4 end
    end
		canShoot = false
		shotClock = 0
	end
	local interval = 10
	local limit = interval
	local max = limit
	if not canShoot and not stg.gameOver then
		if shotClock % interval == 0 and shotClock < limit then spawnBullet() end
		shotClock = shotClock + 1
  end
	if shotClock >= max then canShoot = true end
  for i = 1, #bullets do if bullets[i].active then updateBullet(bullets[i]) end end
end

local function getHit(bullet, isEnemy)
  if player.invulnerableClock == 0 and not stg.gameOver then
    stage.killBullets = true
    if not isEnemy then bullet.active = false end
    explosion.spawn({x = x, y = y, big = true})
    if lives > 0 then
      lives = lives - 1
      player.invulnerableClock = invulnerableLimit
      x = initX
      y = initY
    else stg.gameOver = true end
  end
end

local function update()
  if not stg.gameOver and player.invulnerableClock < invulnerableLimit - 20 then updateMove() end
  updateShot()
  if player.invulnerableClock > 0 then player.invulnerableClock = player.invulnerableClock - 1 end
  player.lives = lives
end

local function drawBullet(bullet)
  love.graphics.draw(images.bullet, bullet.x, bullet.y, bullet.angle, 1, 1, images.bullet:getWidth() / 2, images.bullet:getHeight() / 2)
end

local function draw()
  stg.mask('half', function() for i = 1, #bullets do if bullets[i].active then drawBullet(bullets[i]) end end end)
  local interval = 30
  if not stage.inter and not stg.gameOver and player.invulnerableClock % interval < interval / 2 then
    love.graphics.draw(images.idle, x, y, 0, flip, 1, images.idle:getWidth() / 2, images.idle:getHeight() / 2)
    stg.mask('half', function() love.graphics.draw(images.idleOver, x, y, 0, flip, 1, images.idle:getWidth() / 2, images.idle:getHeight() / 2) end)
  end
  lastX = x
end

return {
  load = load,
  update = update,
  draw = draw,
  invulnerableClock = 0,
  getHit = getHit,
  lives = 0
}
