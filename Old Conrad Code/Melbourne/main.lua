function love.load()
    game = require("src.game")

    game.setup()
end

function love.update(dt)
    if not game.paused then
        world:update(dt)
        player.move(dt)
        game.camClamp()
    end
end

function love.draw()
    if game.state == "menu" then
        game.menu()
    elseif game.state == "lvl1" then
        game.cam:attach()
            game.map:drawLayer(game.map.layers["sky"])
            game.map:drawLayer(game.map.layers["ground"])    
            world:draw()
            player.anim:draw(player.sprite, player.x, player.y, nil, 2, nil, 6, 9)
        game.cam:detach()

        if not game.paused then ui.newButton("Pause", game.window.x / 80, {0, 0, 0}, 10, 10, game.window.x / 6, game.window.y / 12, {1, 1, 1}, {190 / 255, 190 / 255, 190 / 255}, game.pause) love.audio.setVolume( 1.0 ) end

        if game.paused then
            game.pause()
        end
    end

    love.graphics.setFont(love.graphics.newFont("assets/fonts/fontyfont.ttf", 12))
    love.graphics.print(love.graphics.getWidth(), 10, game.window.y - 31)
    love.graphics.print(love.graphics.getHeight(), 10, game.window.y - 20)
end

function love.keypressed(key)
    if key == "escape" then
        game.paused = not game.paused
    end
end