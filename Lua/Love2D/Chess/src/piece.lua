local Settings = require("src.settings")
local Colors = require("src.colors")

local Piece = {}
Piece.__index = Piece

local pieceSpriteSheet = love.graphics.newImage("assets/pieceSpriteSheet.png")

local moveIndicatorSprite = love.graphics.newImage("assets/moveIndicator.png")

local captureIndicatorSprite =
    love.graphics.newImage("assets/captureIndicator.png")

local pieceWidth, pieceHeight =
    pieceSpriteSheet:getWidth() / 6, pieceSpriteSheet:getHeight() / 2

local pieceColumns = { k = 0, q = 1, b = 2, n = 3, r = 4, p = 5 }

function Piece.new(color, type, x, y)
    local self = setmetatable({
        color = color or "white",
        type = type or "p",
        x = x or 1,
        y = y or 1,
        highlighted = false,
    }, Piece)

    self.quad = love.graphics.newQuad(
        pieceColumns[self.type] * pieceWidth,
        (self.color == "white" and 0 or pieceHeight),
        pieceWidth,
        pieceHeight,
        pieceSpriteSheet:getDimensions()
    )

    return self
end

function Piece:isMouseHovering()
    local mx, my = love.mouse.getPosition()
    local sx, sy = self.x * Settings.SQUARE_SIZE, self.y * Settings.SQUARE_SIZE

    return mx >= sx
        and mx < sx + pieceWidth
        and my >= sy
        and my < sy + pieceHeight
end

local function isPathClear(self, x, y)
    local dx, dy = x - self.x, y - self.y

    local stepX = dx ~= 0 and dx / math.abs(dx) or 0
    local stepY = dy ~= 0 and dy / math.abs(dy) or 0

    local checkX, checkY = self.x + stepX, self.y + stepY

    while checkX ~= x or checkY ~= y do
        if _G.Board[checkX] and _G.Board[checkX][checkY] then
            return false -- Blocked
        end

        checkX = checkX + stepX
        checkY = checkY + stepY
    end

    return true
end

local movePatterns = {
    r = function(self, x, y)
        return (self.x == x or self.y == y) and isPathClear(self, x, y)
    end,

    b = function(self, x, y)
        return math.abs(self.x - x) == math.abs(self.y - y)
            and isPathClear(self, x, y)
    end,

    k = function(self, x, y)
        return math.abs(self.x - x) <= 1 and math.abs(self.y - y) <= 1
    end,

    n = function(self, x, y)
        return (math.abs(self.x - x) == 2 and math.abs(self.y - y) == 1)
            or (math.abs(self.x - x) == 1 and math.abs(self.y - y) == 2)
    end,

    p = function(self, x, y, capture)
        local dir = self.color == "white" and -1 or 1

        return (capture and math.abs(self.x - x) == 1 and self.y + dir == y)
            or (
                not capture
                and self.x == x
                and (
                    self.y + dir == y
                    or (
                        self.y == (self.color == "white" and 7 or 2)
                        and self.y + 2 * dir == y
                        and isPathClear(self, x, y)
                    )
                )
            )
    end,
}

movePatterns.q = function(self, x, y)
    return (movePatterns.r(self, x, y) or movePatterns.b(self, x, y))
        and isPathClear(self, x, y)
end

function Piece:canMoveTo(x, y, isCapture)
    return movePatterns[self.type]
            and movePatterns[self.type](self, x, y, isCapture)
        or false
end

function Piece:moveTo(x, y)
    self.x, self.y = x, y
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

        love.graphics.setColor(1, 1, 1, 0.4)

        for x = 1, 8 do
            for y = 1, 8 do
                if self:canMoveTo(x, y) then
                    local targetPiece = _G.Board[x] and _G.Board[x][y]

                    if not targetPiece then
                        love.graphics.draw(
                            moveIndicatorSprite,
                            (x - 1) * Settings.SQUARE_SIZE,
                            (y - 1) * Settings.SQUARE_SIZE
                        )
                    elseif targetPiece.color ~= self.color then
                        love.graphics.draw(
                            captureIndicatorSprite,
                            (x - 1) * Settings.SQUARE_SIZE,
                            (y - 1) * Settings.SQUARE_SIZE
                        )
                    end
                end
            end
        end

        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(
        pieceSpriteSheet,
        self.quad,
        (self.x - 1) * Settings.SQUARE_SIZE,
        (self.y - 1) * Settings.SQUARE_SIZE
    )
end

return Piece
