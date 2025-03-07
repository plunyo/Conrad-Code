local Settings = require("src.settings")
local Colors = require("src.colors")
local Piece = require("src.piece")

local Board = {}

function Board.draw()
    for x = 0, Settings.BOARD_SIZE - 1 do
        for y = 0, Settings.BOARD_SIZE - 1 do
            love.graphics.setColor(
                (x + y) % 2 == 0 and Colors.LIGHT_TILE or Colors.DARK_TILE
            )

            love.graphics.rectangle(
                "fill",
                x * Settings.SQUARE_SIZE,
                y * Settings.SQUARE_SIZE,
                Settings.SQUARE_SIZE,
                Settings.SQUARE_SIZE
            )
        end
    end

    love.graphics.setColor({ 1, 1, 1, 1 })
end

return Board
