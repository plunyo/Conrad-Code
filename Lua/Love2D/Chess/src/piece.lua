local Settings = require("src.settings")
local Colors = require("src.colors")

local Piece = {}
Piece.__index = Piece

local pieceSpriteSheet = love.graphics.newImage("assets/pieceSpriteSheet.png")
local pieceWidth = pieceSpriteSheet:getWidth() / 6
local pieceHeight = pieceSpriteSheet:getHeight() / 2

local pieceColumns = {
    k = 0, -- King
    q = 1, -- Queen
    b = 2, -- Bishop
    n = 3, -- Knight
    r = 4, -- Rook
    p = 5, -- Pawn
}

function Piece.new(color, type, x, y)
    local self = setmetatable({}, Piece)

    self.color = color or "white"
    self.type = type or "p"

    self.x = x or 1
    self.y = y or 1

    self.quad = self:setQuad()

    self.highlighted = false

    return self
end

function Piece:setQuad()
    local column = pieceColumns[self.type]

    if column == nil then
        error("Invalid piece type: " .. tostring(self.type))
    end

    local x = column * pieceWidth
    local y = (self.color == "white" and 0 or pieceHeight)

    return love.graphics.newQuad(
        x,
        y,
        pieceWidth,
        pieceHeight,
        pieceSpriteSheet:getDimensions()
    )
end

function Piece:isMouseHovering()
    local mouseX, mouseY = love.mouse.getPosition()

    return mouseX >= self.x * Settings.SQUARE_SIZE
        and mouseX < self.x * Settings.SQUARE_SIZE + pieceWidth
        and mouseY >= self.y * Settings.SQUARE_SIZE
        and mouseY < self.y * Settings.SQUARE_SIZE + pieceHeight
end

function Piece:moveTo(x, y)
    self.x = x
    self.y = y
end

function Piece:draw()
    if self.highlighted then
        love.graphics.setColor(Colors.HIGHLIGHT)

        love.graphics.rectangle(
            "fill",
            (self.x - 1) * Settings.SQUARE_SIZE,
            (self.y - 1) * Settings.SQUARE_SIZE,
            Settings.SQUARE_SIZE,
            Settings.SQUARE_SIZE
        )

        love.graphics.setColor({ 1, 1, 1, 1 })
    end

    love.graphics.draw(
        pieceSpriteSheet,
        self.quad,
        (self.x - 1) * Settings.SQUARE_SIZE,
        (self.y - 1) * Settings.SQUARE_SIZE
    )
end

return Piece
