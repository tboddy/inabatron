local spawnClock = 0
local spawnLimit = 30
local increasedWave = false
local nextWave

function waveOne()
  for i = 1, 15 do stage.spawnGrunt(i % 2 == 0) end
  for i = 1, 2 do stage.spawnRabbit() end
  nextWave = waveTwo
end

function waveTwo()
  for i = 1, 17 do stage.spawnGrunt() end
  for i = 1, 5 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 3 do stage.spawnRabbit() end
  nextWave = waveThree
end

function waveThree()
  for i = 1, 22 do stage.spawnGrunt() end
  for i = 1, 6 do stage.spawnHulk() end
  for i = 1, 3 do stage.spawnSpheroid(i % 3) end
  for i = 1, 6 do stage.spawnRabbit() end
  nextWave = waveFour
end

function waveFour()
  for i = 1, 34 do stage.spawnGrunt() end
  for i = 1, 7 do stage.spawnHulk() end
  for i = 1, 4 do stage.spawnSpheroid(i % 3) end
  for i = 1, 6 do stage.spawnRabbit() end
  nextWave = waveFive
end

function waveFive() -- brain wave
  for i = 1, 20 do stage.spawnGrunt() end
  for i = 1, 15 do stage.spawnBrain(i % 3) end
  for i = 1, 1 do stage.spawnSpheroid(i % 3) end
  for i = 1, 16 do stage.spawnRabbit() end
  nextWave = waveSix
end

function waveSix()
  for i = 1, 32 do stage.spawnGrunt() end
  for i = 1, 7 do stage.spawnHulk() end
  for i = 1, 4 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveSeven
end

function waveSeven() -- tank wave
  for i = 1, 12 do stage.spawnHulk() end
  for i = 1, 10 do stage.spawnTank(i % 3) end
  for i = 1, 12 do stage.spawnRabbit() end
  nextWave = waveEight
end

function waveEight()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveNine
end

function waveNine() -- grunt mob
  for i = 1, 60 do stage.spawnGrunt() end
  for i = 1, 4 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTen
end

function waveTen() -- brain wave
  for i = 1, 25 do stage.spawnGrunt() end
  for i = 1, 20 do stage.spawnBrain(i % 3) end
  stage.spawnSpheroid(1)
  for i = 1, 22 do stage.spawnRabbit() end
  nextWave = waveEleven
end

function waveEleven()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwelve
end

function waveTwelve() -- tank wave
  for i = 1, 13 do stage.spawnHulk() end
  for i = 1, 12 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirteen
end

function waveThirteen()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveFourteen
end

function waveFourteen()
  for i = 1, 27 do stage.spawnGrunt() end
  for i = 1, 20 do stage.spawnHulk() end
  for i = 1, 2 do stage.spawnSpheroid(i % 3) end
  for i = 1, 15 do stage.spawnRabbit() end
  nextWave = waveFifteen
end

function waveFifteen() -- brain wave
  for i = 1, 25 do stage.spawnGrunt() end
  for i = 1, 2 do stage.spawnHulk() end
  for i = 1, 20 do stage.spawnBrain(i % 3) end
  stage.spawnSpheroid(1)
  for i = 1, 22 do stage.spawnRabbit() end
  nextWave = waveSixteen
end

function waveSixteen()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 3 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveSeventeen
end

function waveSeventeen() -- tank wave
  for i = 1, 14 do stage.spawnHulk() end
  for i = 1, 12 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveEighteen
end

function waveEighteen()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveNineteen
end

function waveNineteen() -- grunt mob
  for i = 1, 70 do stage.spawnGrunt() end
  for i = 1, 3 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwenty
end

function waveTwenty() -- brain wave
  for i = 1, 25 do stage.spawnGrunt() end
  for i = 1, 2 do stage.spawnHulk() end
  for i = 1, 20 do stage.spawnBrain(i % 3) end
  for i = 1, 2 do stage.spawnSpheroid(i % 3) end
  for i = 1, 24 do stage.spawnRabbit() end
  nextWave = waveTwentyOne
end

function waveTwentyOne()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwentyTwo
end

function waveTwentyTwo() -- tank wave
  for i = 1, 15 do stage.spawnHulk() end
  for i = 1, 12 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwentyThree
end

function waveTwentyThree()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwentyFour
end

function waveTwentyFour()
  for i = 1, 13 do stage.spawnHulk() end
  for i = 1, 6 do stage.spawnSpheroid(i % 3) end
  for i = 1, 7 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwentyFive
end

function waveTwentyFive() -- brain wave
  for i = 1, 25 do stage.spawnGrunt() end
  stage.spawnHulk()
  for i = 1, 21 do stage.spawnBrain(i % 3) end
  stage.spawnSpheroid(1)
  for i = 1, 26 do stage.spawnRabbit() end
  nextWave = waveTwentySix
end

function waveTwentySix()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwentySeven
end

function waveTwentySeven() -- tank wave
  for i = 1, 16 do stage.spawnHulk() end
  for i = 1, 12 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwentyEight
end

function waveTwentyEight()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  stage.spawnTank(1)
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveTwentyNine
end

function waveTwentyNine() -- grunt mob
  for i = 1, 75 do stage.spawnGrunt() end
  for i = 1, 4 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  stage.spawnTank(1)
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirty
end

function waveThirty() -- brain wave
  for i = 1, 25 do stage.spawnGrunt() end
  stage.spawnHulk()
  for i = 1, 22 do stage.spawnBrain(i % 3) end
  stage.spawnSpheroid(1)
  stage.spawnTank(2)
  for i = 1, 25 do stage.spawnRabbit() end
  nextWave = waveThirtyOne
end

function waveThirtyOne()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  stage.spawnTank(1)
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirtyTwo
end

function waveThirtyTwo() -- tank wave
  for i = 1, 16 do stage.spawnHulk() end
  for i = 1, 13 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirtyThree
end

function waveThirtyThree()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  stage.spawnTank(1)
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirtyFour
end

function waveThirtyFour()
  for i = 1, 30 do stage.spawnGrunt() end
  for i = 1, 25 do stage.spawnHulk() end
  for i = 1, 2 do stage.spawnSpheroid(i % 3) end
  for i = 1, 2 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirtyFive
end

function waveThirtyFive()-- brain wave
  for i = 1, 27 do stage.spawnGrunt() end
  for i = 1, 2 do stage.spawnHulk() end
  for i = 1, 23 do stage.spawnBrain(i % 3) end
  stage.spawnSpheroid(1)
  for i = 1, 2 do stage.spawnTank(i % 3) end
  for i = 1, 25 do stage.spawnRabbit() end
  nextWave = waveThirtySix
end

function waveThirtySix()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 2 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirtySeven
end

function waveThirtySeven() -- tank wave
  for i = 1, 16 do stage.spawnHulk() end
  for i = 1, 14 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirtyEight
end

function waveThirtyEight()
  for i = 1, 35 do stage.spawnGrunt() end
  for i = 1, 8 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  for i = 1, 2 do stage.spawnTank(i % 3) end
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveThirtyNine
end

function waveThirtyNine() -- grunt mob
  for i = 1, 80 do stage.spawnGrunt() end
  for i = 1, 6 do stage.spawnHulk() end
  for i = 1, 5 do stage.spawnSpheroid(i % 3) end
  stage.spawnTank(1)
  for i = 1, 9 do stage.spawnRabbit() end
  nextWave = waveFourty
end

function waveFourty() -- brain wave
  for i = 1, 30 do stage.spawnGrunt() end
  for i = 1, 2 do stage.spawnHulk() end
  for i = 1, 25 do stage.spawnBrain(i % 3) end
  stage.spawnSpheroid(1)
  stage.spawnTank(2)
  for i = 1, 30 do stage.spawnRabbit() end
  nextWave = waveTwentyOne
end

local waveTitles = {

  false,
  false,
  false,
  false,
  'APPOSSHA WAVE',

  false,
  'AKKOROKAMUI WAVE',
  false,
  'WANI MOB',
  'APPOSSHA WAVE',

  false,
  'AKKOROKAMUI WAVE',
  false,
  false,
  'APPOSSHA WAVE',

  false,
  'AKKOROKAMUI WAVE',
  false,
  'WANI MOB',
  'APPOSSHA WAVE',

  false,
  'AKKOROKAMUI WAVE',
  false,
  false,
  'APPOSSHA WAVE',

  false,
  'AKKOROKAMUI WAVE',
  false,
  'WANI MOB',
  'APPOSSHA WAVE',

  false,
  'AKKOROKAMUI WAVE',
  false,
  false,
  'APPOSSHA WAVE',

  false,
  'AKKOROKAMUI WAVE',
  false,
  'WANI MOB',
  'APPOSSHA WAVE'

}

local currentWave = waveOne

local function update()
  if stage.rabbitCount == 0 then
    if stage.waveClock >= stage.waveLimit then
      stage.inter = false
      if spawnClock >= spawnLimit and not stg.gameOver then
        currentWave()
        stg.waveTitle = false
        currentWave = nextWave
        increasedWave = false
        stage.waveClock = 0
      end
      spawnClock = spawnClock + 1
    else
      spawnClock = 0
      stage.waveClock = stage.waveClock + 1
      stage.killEnemies = true
      stage.inter = true
      stage.killBullets = true
      if not increasedWave then
        stg.currentWave = stg.currentWave + 1
        stg.currentWaveTitle = stg.currentWaveTitle + 1
        if stg.currentWave >= 41 then stg.currentWaveTitle = 21 end
        if waveTitles[stg.currentWave] then stg.waveTitle = waveTitles[stg.currentWave] end
        increasedWave = true
        if stg.currentWave > 1 then sound.playSfx('clearwave') end
        if stg.currentWave >= 256 then love.event.quit() end
      end
    end
  end
end

return {
  update = update
}
