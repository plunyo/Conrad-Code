local ui = {}

function ui.newButton(text, textSize, textColor, x, y, w, h, buttonColor, highlightColor, fn)
    local font = love.graphics.newFont('assets/fonts/fontyfont.ttf', textSize)
    local textWidth = font:getWidth(text)
    local labelx, labely = x + (w - textWidth) / 2, y + (h - font:getHeight()) / 2
    
    love.graphics.setColor(buttonColor)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1)

    local mx, my = love.mouse.getPosition()
    if mx >= x and mx <= x + w and my >= y and my <= y + h then
        love.graphics.setColor(highlightColor)
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(1, 1, 1)
        if love.mouse.isDown(1) then
            fn()
        end
    end
    
    love.graphics.setFont(font)
    love.graphics.setColor(textColor)
    love.graphics.print(text, labelx, labely)
    love.graphics.setColor(1, 1, 1)
end

function ui.bar(x, y, w, h, value, color, outline, outlineColor)
    love.graphics.setColor(outlineColor)

    if outline then
        love.graphics.rectangle("line", x, y, w, h)
    end

    love.graphics.setColor(color)
    love.graphics.rectangle("fill", x, y, w * value, h)
    love.graphics.setColor(1, 1, 1)
end

return ui
