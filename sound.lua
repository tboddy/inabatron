local currentSound, sfxTypes, bgmTypes

local function load()
  sfxTypes = {'playershot', 'explosion1', 'explosion2', 'rabbit', 'lostrabbit', 'bullet1', 'bullet2', 'bullet3', 'playerhit', 'clearwave', 'menuchange', 'start', 'gameover'}
  bgmTypes = {'stage', 'start'}
  for i = 1, #sfxTypes do
    sound.sfxFiles[sfxTypes[i]] = love.audio.newSource('sfx/' .. sfxTypes[i] .. '.wav', 'static')
    sound.sfxFiles[sfxTypes[i]]:setVolume(sound.sfxVolume)
  end
  sound.sfxFiles.playershot:setVolume(sound.sfxVolume / 4)
  for i = 1, #bgmTypes do
    sound.bgmFiles[bgmTypes[i]] = love.audio.newSource('bgm/' .. bgmTypes[i] .. '.ogg', 'static')
		sound.bgmFiles[bgmTypes[i]]:setVolume(sound.bgmVolume)
		sound.bgmFiles[bgmTypes[i]]:setLooping(true)
  end
end

local function playSfx(sfx)
  if sound.sfxFiles[sfx]:isPlaying() then sound.sfxFiles[sfx]:stop() end
  sound.sfxFiles[sfx]:play()
end

local function playBgm(bgm)
  for i = 1, #bgmTypes do
    if sound.bgmFiles[bgmTypes[i]]:isPlaying() then sound.bgmFiles[bgmTypes[i]]:stop() end
  end
  sound.bgmFiles[bgm]:play()
end

return {
  load = load,
  sfxFiles = {},
  bgmFiles = {},
  sfx = false,
  bgm = false,
	sfxVolume = 1,
	bgmVolume = 1,
  playSfx = playSfx,
  playBgm = playBgm
}
