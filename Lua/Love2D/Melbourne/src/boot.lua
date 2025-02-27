--[[

boot.lua

]]--

local boot = {}

function boot.game()
    print("game booted")

    game = require('src.game')
    sound = require('src.sounds')
    ui = require('src.ui')
    local saves = require('src.saves')

    game.window.w, game.window.h = love.window.getDesktopDimensions()

    game.fs(1024, 768, true)

    game.state = 'savemenu'
end

return boot
