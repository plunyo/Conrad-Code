local ColorRect = require("src.classes.ui.ColorRect")
local Control = require("src.classes.ui.Control")
local Signal = require("src.classes.Signal")
local Label = require("src.classes.ui.Label")
local utils = require("src.utils")

local Button = {
    onClicked = Signal:new(),

    text = "",
    textColor = { 0, 0, 0, 1 },

    isClicked = false,
}
Button.__index = Button

function Button:new(size, position, text, color, outline)
    local instance =
        setmetatable(Control.new(self, size, position, outline), Button)

    instance.onClicked = Signal:new()

    instance.text = text
    instance.isClicked = false

    instance.color = color

    instance.background =
        ColorRect:new(instance.size, instance.position, color, outline)
    instance.label = Label:new(
        instance.position,
        instance.text,
        instance.textColor,
        instance.font
    )

    return instance
end

function Button:isMouseHovering(x, y)
    local left = self.position.x - self.size.x / 2
    local right = self.position.x + self.size.x / 2

    local top = self.position.y - self.size.y / 2
    local bottom = self.position.y + self.size.y / 2

    return x >= left and x <= right and y >= top and y <= bottom
end

function Button:update()
    local mouseX, mouseY = love.mouse.getPosition()

    if self:isMouseHovering(mouseX, mouseY) then
        if love.mouse.isDown(1) and not self.isClicked then
            self.isClicked = true
        elseif not love.mouse.isDown(1) and self.isClicked then
            self.onClicked:emit()

            self.isClicked = false
        end
    else
        self.isClicked = false
    end
end

function Button:draw()
    local colorFactor = self.isClicked and 0.6
        or (
            self:isMouseHovering(love.mouse.getX(), love.mouse.getY())
                and 0.8
            or 1
        )
    local adjustedColor = utils.adjustBrightness(self.color, colorFactor)

    self.background.color = adjustedColor
    self.background:draw()

    self.label:draw()

    love.graphics.setColor(1, 1, 1, 1)
end

return Button
