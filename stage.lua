local killBulletLimit, bulletAnimateInterval, bulletAnimateMax, images, bullets, killBulletClock

local function loadEnemies()
  local types = {'wani', 'wanitop', 'rabbit', 'rabbittop', 'snake', 'appossha', 'apposshatop', 'oonamazu', 'oonamazutop', 'masakado', 'masakadotop', 'amikiri', 'amikiritop', 'akkorokamui', 'akkorokamuitop'}
  for i = 1, 92 do stage.enemies[i] = {} end
  for i = 1, #types do images[types[i]] = love.graphics.newImage('img/enemies/' .. types[i] .. '.png') end
end

local function loadBullets()
  bullets = {}
  local types = {'small', 'big', 'bolt', 'arrow', 'pill'}
  for i = 1, 1024 do bullets[i] = {} end
  for i = 1, #types do
    for j = 0, 3 do
      images[types[i] .. j] = love.graphics.newImage('img/bullets/' .. types[i] .. j .. '.png')
      images[types[i] .. 'Red' .. j] = love.graphics.newImage('img/bullets/' .. types[i] .. '-red' .. j .. '.png')
    end
  end
end

local function load()
  killBulletClock = 0
  killBulletLimit = 60
  bulletAnimateInterval = 8
  bulletAnimateMax = bulletAnimateInterval * 4
  images = {}
  loadEnemies()
  loadBullets()
  stg.loadImages(images)
end

local function spawnEnemy(initFunc, updateFunc)
	local enemy = stage.enemies[stg.getIndex(stage.enemies)]
	enemy.active = true
  enemy.health = 1
  enemy.clock = 0
  enemy.flags = {}
  enemy.opposite = false
  enemy.speed = 0
  enemy.seen = false
  enemy.score = 0
  enemy.hit = false
  enemy.boss = false
  enemy.borderRotation = 0
  enemy.xScale = 1
  -- if math.random() < .5 then enemy.xScale = 1 else enemy.xScale = -1 end
  enemy.suicideFunc = false
	initFunc(enemy)
  enemy.maxHealth = enemy.health
  enemy.width = images[enemy.type]:getWidth()
  enemy.height = images[enemy.type]:getHeight()
	enemy.updateFunc = updateFunc
end

local getMod = 16
local getLimit = stg.grid * 2.5

function getX(enemy)
  enemy.x = math.random() * (stg.width - getMod * 2) + getMod
  if enemy.x >= stg.width / 2 - getLimit and enemy.x < stg.width / 2 + getLimit then getX(enemy) end
end

function getY(enemy)
  enemy.y = math.random() * (stg.height - getMod * 2) + getMod
  if enemy.y >= stg.height / 2 - getLimit and enemy.y < stg.height / 2 + getLimit then getY(enemy) end
end

local function place(enemy)
  getX(enemy)
  getY(enemy)
end

local function bounce(enemy)
  if enemy.x > stg.width - images[enemy.type]:getWidth() / 2 then
    enemy.x = stg.width - images[enemy.type]:getWidth() / 2
    enemy.angle = math.pi + (math.tau - (enemy.angle % math.tau))
    enemy.xScale = enemy.xScale * -1
  elseif enemy.x < images[enemy.type]:getWidth() / 2 then
    enemy.x = math.pi + images[enemy.type]:getWidth() / 2
    enemy.angle = math.pi + (math.tau - (enemy.angle % math.tau))
    enemy.xScale = enemy.xScale * -1
  end
  if enemy.y > stg.height - images[enemy.type]:getHeight() / 2 then
    enemy.y = stg.height - images[enemy.type]:getHeight() / 2
    enemy.angle = -math.pi - (math.tau - (enemy.angle % math.tau)) + math.pi / 2
  elseif enemy.y < images[enemy.type]:getHeight() / 2 then
    enemy.angle = -math.pi - (math.tau - (enemy.angle % math.tau)) + math.pi / 2
    enemy.y = images[enemy.type]:getHeight() / 2
  end
end

local function tweak(enemy)
  if math.random() < .5 then enemy.xScale = -1 end
  local rotateMod = math.pi / 15
  enemy.rotation = -rotateMod + rotateMod * 2 * math.random()
end

local function spawnGrunt()
  spawnEnemy(function(enemy)
    place(enemy)
    enemy.flags.targetOffset = stg.grid * 6
    enemy.angle = 0
    enemy.speed = .35
    enemy.health = 1
    enemy.score = 100
    enemy.type = 'wani'
    enemy.flags.topImage = 'wanitop'
    tweak(enemy)
  end, function(enemy)
    if enemy.clock % 60 == 0 then
      local target = {
        x = player.x + math.cos(math.tau * math.random()) * enemy.flags.targetOffset,
        y = player.y + math.sin(math.tau * math.random()) * enemy.flags.targetOffset
      }
      enemy.angle = stg.getAngle(enemy, target)
    end
    bounce(enemy)
  end)
end

local function spawnHulk()
  spawnEnemy(function(enemy)
    enemy.type = 'amikiri'
    enemy.flags.topImage = 'amikiritop'
    place(enemy)
    enemy.angle = 0
    enemy.speed = .2
    tweak(enemy)
  end, function(enemy)
    enemy.speed = .2
    if enemy.flags.hit then
      enemy.speed = -1.75
      enemy.flags.hit = false
    end
    for i = 1, #stage.enemies do
      local angle = false
      if stage.enemies[i].type == 'rabbit' and stage.enemies[i].active and not angle then
        local mod = math.pi / 45
        angle = stg.getAngle(enemy, stage.enemies[i]) - mod + mod * 2 * math.random()
        if math.sqrt((stage.enemies[i].x - enemy.x) * (stage.enemies[i].x - enemy.x) + (stage.enemies[i].y - enemy.y) * (stage.enemies[i].y - enemy.y)) < enemy.height / 2 then
          stage.enemies[i].active = false
          if not stg.gameOver then sound.playSfx('lostrabbit') end
        end
      end
      if angle then
        if enemy.clock % 60 == 0 then
          enemy.angle = angle
          enemy.rotation = angle - math.pi / 2
        end
      end
    end
  end)
end

local function spawnSpheroid(timeOffset)
  local function spawnBullets(enemy)
    local count = 7
    local angle = math.tau * math.random()
    for i = 1, count do
      stage.spawnBullet(function(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.angle = angle
        bullet.speed = 1
        bullet.type = 'big'
      end)
      angle = angle + math.tau / count
    end
    if not stg.gameOver then sound.playSfx('bullet1') end
  end
  spawnEnemy(function(enemy)
    enemy.type = 'oonamazu'
    enemy.flags.topImage = 'oonamazutop'
    place(enemy)
    enemy.angle = math.tau * math.random()
    enemy.flags.timeOffset = timeOffset
    enemy.speed = .2
    enemy.score = 1000
    tweak(enemy)
  end, function(enemy)
    local interval = 120
    if enemy.clock % interval == enemy.flags.timeOffset * 30 then spawnBullets(enemy) end
    bounce(enemy)
  end)
end

local function spawnBrain(timeOffset)
  local function spawnBullets(enemy)
    local mod = math.pi / 4
    local angle = enemy.flags.bulletAngle - mod
    for i = 1, 3 do
      stage.spawnBullet(function(bullet)
        bullet.x = enemy.flags.pos.x
        bullet.y = enemy.flags.pos.y
        bullet.angle = angle
        bullet.speed = 1.2
        bullet.type = 'pill'
      end)
      angle = angle + mod
    end
  end
  spawnEnemy(function(enemy)
    enemy.type = 'appossha'
    enemy.flags.topImage = 'apposshatop'
    place(enemy)
    enemy.flags.targetOffset = stg.grid * 6
    enemy.angle = math.tau * math.random()
    enemy.flags.timeOffset = timeOffset
    enemy.speed = .25
    enemy.score = 500
    tweak(enemy)
    enemy.flags.timeOffset = timeOffset
  end, function(enemy)
    if enemy.clock % 120 == 0 then
      local target = {
        x = player.x + math.cos(math.tau * math.random()) * enemy.flags.targetOffset,
        y = player.y + math.sin(math.tau * math.random()) * enemy.flags.targetOffset
      }
      enemy.angle = stg.getAngle(enemy, target)
    end
    bounce(enemy)
    local start = enemy.flags.timeOffset * 30
    local interval = 180
    local limit = 20
    local bInterval = 10
    if enemy.clock % interval == start then
      enemy.flags.pos = {x = enemy.x, y = enemy.y}
      enemy.flags.bulletAngle = stg.getAngle(enemy.flags.pos, player)
      if not stg.gameOver then sound.playSfx('bullet2') end
    end
    if enemy.clock % interval >= start and enemy.clock % bInterval == 0 and enemy.clock % interval < start + limit then
      spawnBullets(enemy)
    end
  end)
end

local function spawnTank(timeOffset)
  local function spawnBullets(enemy)
    local count = 3
    local angle = math.tau * math.random()
    if not stg.gameOver then sound.playSfx('bullet3') end
    for i = 1, count do
      stage.spawnBullet(function(bullet)
        bullet.x = enemy.x
        bullet.y = enemy.y
        bullet.angle = angle
        bullet.speed = 1.25
        bullet.type = 'small'
      end, function(bullet)
        local img = images[bullet.type.. '0']
        if not bullet.flags.flipped then
          if bullet.x > stg.width - img:getWidth() / 2 then
            bullet.x = stg.width - img:getWidth() / 2
            bullet.angle = math.pi + (math.tau - (bullet.angle % math.tau))
            bullet.xScale = bullet.xScale * -1
            bullet.flags.flipped = true
          elseif bullet.x < img:getWidth() / 2 then
            bullet.x = math.pi + img:getWidth() / 2
            bullet.angle = math.pi + (math.tau - (bullet.angle % math.tau))
            bullet.xScale = bullet.xScale * -1
            bullet.flags.flipped = true
          end
          if bullet.y > stg.height - img:getHeight() / 2 then
            bullet.y = stg.height - img:getHeight() / 2
            bullet.angle = -math.pi - (math.tau - (bullet.angle % math.tau)) + math.pi / 2
            bullet.flags.flipped = true
          elseif bullet.y < img:getHeight() / 2 then
            bullet.angle = -math.pi - (math.tau - (bullet.angle % math.tau)) + math.pi / 2
            bullet.y = img:getHeight() / 2
            bullet.flags.flipped = true
          end
        end
      end)
      angle = angle + math.tau / count
    end
  end
  spawnEnemy(function(enemy)
    enemy.type = 'akkorokamui'
    enemy.flags.topImage = 'akkorokamuitop'
    place(enemy)
    enemy.speed = .2
    enemy.angle = math.tau * math.random()
    enemy.flags.timeOffset = timeOffset
    enemy.score = 1000
    tweak(enemy)
  end, function(enemy)
    bounce(enemy)
    local interval = 120
    if enemy.clock % interval == enemy.flags.timeOffset * 30 then spawnBullets(enemy) end
  end)
end

local function spawnRabbit()
  local rabitColors = {'redLight', 'green', 'blueLight'}
  spawnEnemy(function(rabbit)
    place(rabbit)
    rabbit.type = 'rabbit'
    rabbit.flags.color = rabitColors[math.floor(math.random() * 3) + 1]
    rabbit.speed = .15
    rabbit.angle = math.tau * math.random()
    rabbit.flags.angleDir = 1
    rabbit.flags.angleLimit = math.pi / 30
    rabbit.rotation = 0
    rabbit.flags.count = 0
    if math.random() < .5 then rabbit.xScale = -1 end
  end, function(rabbit)
    bounce(rabbit)
    rabbit.rotation = rabbit.rotation + rabbit.flags.angleDir * .0015
    if rabbit.rotation < -rabbit.flags.angleLimit or rabbit.rotation > rabbit.flags.angleLimit then rabbit.flags.angleDir = rabbit.flags.angleDir * -1 end
    if rabbit.flags.caught then
      stg.currentScore = stg.currentScore + 1000
      rabbit.active = false
    end
  end)
end

local function updateEnemy(enemy)
  if enemy.type == 'rabbit' then stage.rabbitCount = stage.rabbitCount + 1
  else stage.enemyCount = stage.enemyCount + 1 end
  if enemy.boss then
    stage.bossHealth = enemy.health
    stage.bossMaxHealth = enemy.maxHealth
  end
  if enemy.health <= 0 then
    explosion.spawn({x = enemy.x, y = enemy.y, big = true, type = 'gray'})
    stg.currentScore = stg.currentScore + enemy.score
    if enemy.suicideFunc then enemy.suicideFunc(enemy) end
    enemy.active = false
  end
  if enemy.seen and enemy.active then
    enemy.x = enemy.x + math.cos(enemy.angle) * enemy.speed
    enemy.y = enemy.y + math.sin(enemy.angle) * enemy.speed
    if enemy.updateFunc then enemy.updateFunc(enemy) end
    enemy.borderRotation = enemy.borderRotation + .0025
    if enemy.x < -enemy.width / 2 or enemy.x > stg.width + enemy.width / 2 or enemy.y < -enemy.height / 2 or enemy.y > stg.height + enemy.height / 2 then enemy.active = false end
    enemy.clock = enemy.clock + 1
  elseif not enemy.seen and enemy.active then
    enemy.clock = -1
    enemy.x = enemy.x + math.cos(enemy.angle)
    enemy.y = enemy.y + math.sin(enemy.angle)
    if enemy.x > -enemy.width / 2 and enemy.x < stg.width + enemy.width / 2 and enemy.y > -enemy.height / 2 and enemy.y < stg.height + enemy.height / 2 then enemy.seen = true end
  end
  if enemy.boss and not enemy.active then
    stage.bossHealth = 0
    stage.bossMaxHealth = 0
  end
  if enemy.type ~= 'rabbit' and stage.killEnemies then
    enemy.active = false
    explosion.spawn({x = enemy.x, y = enemy.y, big = true, type = 'gray'})
  end
  if enemy.active and enemy.type ~= 'rabbit' and player.invulnerableClock == 0 then
    if math.sqrt((player.x - enemy.x) * (player.x - enemy.x) + (player.y - enemy.y) * (player.y - enemy.y)) < 1 + enemy.width / 2 then player.getHit(enemy, true) end
  end
end

local function spawnBullet(initFunc, updateFunc)
	if killBulletClock == 0 and not stg.gameOver then
	  local bullet = bullets[stg.getIndex(bullets)]
	  bullet.active = true
		bullet.rotation = 0
    bullet.top = false
    bullet.clock = 0
    bullet.flags = {}
    bullet.speed = 0
    bullet.angle = 0
    if math.random() < .5 then bullet.xScale = 1 else bullet.xScale = -1 end
    if math.random() < .5 then bullet.yScale = 1 else bullet.yScale = -1 end
	  initFunc(bullet)
    if string.find(bullet.type, 'arrow') then bullet.width = 16; bullet.height = 14; bullet.xScale = 1
    elseif string.find(bullet.type, 'big') then bullet.width = 16; bullet.height = 16
    elseif string.find(bullet.type, 'bolt') then bullet.width = 20; bullet.height = 6; bullet.xScale = 1
    elseif string.find(bullet.type, 'pill') then bullet.width = 12; bullet.height = 4; bullet.xScale = 1
    elseif string.find(bullet.type, 'small') then bullet.width = 8; bullet.height = 8 end
    if updateFunc then bullet.updateFunc = updateFunc else bullet.updateFunc = false end
	end
end

local function updateBullet(bullet)
	if bullet.updateFunc then bullet.updateFunc(bullet) end
  bullet.x = bullet.x + math.cos(bullet.angle) * bullet.speed
  bullet.y = bullet.y + math.sin(bullet.angle) * bullet.speed
	if bullet.clock % bulletAnimateMax < bulletAnimateInterval then bullet.animateIndex = 0
	elseif bullet.clock % bulletAnimateMax >= bulletAnimateInterval and bullet.clock % bulletAnimateMax < bulletAnimateInterval * 2 then bullet.animateIndex = 1
  elseif bullet.clock % bulletAnimateMax >= bulletAnimateInterval * 2 and bullet.clock % bulletAnimateMax < bulletAnimateInterval * 3 then bullet.animateIndex = 2
  elseif bullet.clock % bulletAnimateMax >= bulletAnimateInterval * 3 then bullet.animateIndex = 3 end
	if string.find(bullet.type, 'bolt') or string.find(bullet.type, 'arrow') or string.find(bullet.type, 'pill') then bullet.rotation = bullet.angle end
	bullet.clock = bullet.clock + 1
	if bullet.x < -bullet.width * 2 or bullet.x > stg.width + bullet.width * 2 or bullet.y < -bullet.height * 2 or bullet.y > stg.height + bullet.height * 2 then bullet.active = false
	elseif killBulletClock > 0 then
    if string.find(bullet.type, 'Red') then explosion.spawn({x = bullet.x, y = bullet.y, type = 'red'}) else explosion.spawn({x = bullet.x, y = bullet.y}) end
		bullet.active = false
	elseif bullet.active and player.invulnerableClock == 0 then
    if math.sqrt((player.x - bullet.x) * (player.x - bullet.x) + (player.y - bullet.y) * (player.y - bullet.y)) < 1 + bullet.height / 2 then player.getHit(bullet) end
  end
end

local function update()
  stage.enemyCount = 0
  stage.rabbitCount = 0
  for i = 1, #stage.enemies do if stage.enemies[i].active then updateEnemy(stage.enemies[i]) end end
  for i = 1, #bullets do if bullets[i].active then updateBullet(bullets[i]) end end
  if stage.killBullets then
    killBulletClock = killBulletLimit
    stage.killBullets = false
  end
  if killBulletClock > 0 then killBulletClock = killBulletClock - 1 end
  stage.killBulletClock = killBulletClock
  stage.killEnemies = false
end

local function drawEnemy(enemy)
  local r = 0
  if enemy.type == 'sharkblue' then love.graphics.setColor(stg.colors.blueDark)
  elseif enemy.type == 'amikiri' then love.graphics.setColor(stg.colors.redDark) end
  if enemy.type == 'rabbit' then
    r = enemy.width / 3 * 2
    love.graphics.setColor(stg.colors.brown)
  end
  if r > 0 then stg.mask('quarter', function() love.graphics.circle('fill', enemy.x, enemy.y, r) end) end
  love.graphics.setColor(stg.colors.white)
  love.graphics.draw(images[enemy.type], enemy.x, enemy.y, enemy.rotation, enemy.xScale, 1, enemy.width / 2, enemy.height / 2)
  if enemy.type == 'rabbit' then
    love.graphics.setColor(stg.colors[enemy.flags.color])
    stg.mask('half', function() love.graphics.draw(images.rabbittop, enemy.x, enemy.y, enemy.rotation, enemy.xScale, 1, enemy.width / 2, enemy.height / 2) end)
    love.graphics.setColor(stg.colors.white)
  elseif enemy.flags.topImage then
    stg.mask('half', function() love.graphics.draw(images[enemy.flags.topImage], enemy.x, enemy.y, enemy.rotation, enemy.xScale, 1, enemy.width / 2, enemy.height / 2) end)
  end
end

local function drawBullets()
	local function drawBullet(bullet)
    if not bullet.flags.invisible then
      love.graphics.draw(images[bullet.type .. bullet.animateIndex], bullet.x, bullet.y, bullet.rotation, bullet.xScale, bullet.yScale, bullet.width / 2, bullet.height / 2)
    end
  end
	for i = 1, #bullets do if bullets[i].active and not bullets[i].top then drawBullet(bullets[i]) end end
	for i = 1, #bullets do if bullets[i].active and bullets[i].top then drawBullet(bullets[i]) end end
end

local function draw()
  for i = 1, #stage.enemies do if stage.enemies[i].active then drawEnemy(stage.enemies[i]) end end
  drawBullets()
end

return {
  load = load,
  update = update,
  draw = draw,
  enemies = {},
  spawnEnemy = spawnEnemy,
  spawnBullet = spawnBullet,
  killBullets = false,
  killBulletClock = 0,
  enemyCount = 0,
  rabbitCount = 0,
  spawnGrunt = spawnGrunt,
  spawnRabbit = spawnRabbit,
  spawnHulk = spawnHulk,
  spawnSpheroid = spawnSpheroid,
  spawnBrain = spawnBrain,
  spawnTank = spawnTank,
  killEnemies = false,
  inter = true,
  waveLimit = 80,
  waveClock = 0
}
