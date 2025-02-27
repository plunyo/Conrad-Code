--[[

sound.lua

handles all the audio related stuff

]]--
local sound = {}

function sound.play(soundFile, loop)
    local noise = love.audio.newSource('assets/audio/' .. soundFile, 'static')
    noise:setLooping(loop or false)
    love.audio.play(noise)
end

return sound
