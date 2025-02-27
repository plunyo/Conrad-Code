function love.load()
    boot = require('src.boot')

    boot.game()
end

function love.draw()
    if game.state == 'savemenu' then
        game.saveMenu()
    elseif game.state == 'menu' then
        game.menu()
    end
end

function love.keypressed(key)
    if key == 'backspace' then
        love.event.quit()
    elseif key == 'f11' then
        game.toggleFullscreen()
    end
end
