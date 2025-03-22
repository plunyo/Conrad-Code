function love.load()
    game = require("src.game")

    game.setup()
end

function love.update(dt)
    world:update(dt)
    player.move(dt)
    game.cam:lookAt(player.x, player.y)
end

function love.draw()
    if game.state == "menu" then
        game.menu()
    elseif game.state == "lvl1" then
        if game.paused then
            game.paused()
        else
            game.cam:attach()
                game.map:drawLayer(game.map.layers["ground"])
                game.map:drawLayer(game.map.layers["tree"])
                world:draw()
                player.anim:draw(player.sprite, player.x, player.y, nil, 6, nil, 6, 9)
                ui.newButton("Pause", game.window / 80, {0, 0, 0}, game.window.x / 2 - game.window.x / 6 / 2, game.window.y / 2, game.window.x / 6, game.window.y / 12, {1, 1, 1}, {190 / 255, 190 / 255, 190 / 255}, game.pause)
            game.cam:detach()
        end
    end

    love.graphics.setFont(love.graphics.newFont("assets/fonts/fontyfont.ttf", 12))
    love.graphics.print(love.graphics.getWidth(), 10, 10)
    love.graphics.print(love.graphics.getHeight(), 10, 25)
end

function love.keypressed(key)
    if key == "escape" then
        game.paused = not game.paused
    end
end