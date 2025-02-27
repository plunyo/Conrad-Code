local ui = {}

function ui.newButton(text, textSize, textColor, x, y, w, h, buttonColor, highlightColor, fn, params)
    local font = love.graphics.newFont('assets/fonts/fontyfont.ttf', textSize)
    local textWidth = font:getWidth(text)
    local labelx, labely = x + (w - textWidth) / 2, y + (h - font:getHeight()) / 2
    
    love.graphics.setColor(buttonColor)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1) -- Reset color to default (white)

    local mx, my = love.mouse.getPosition()
    if mx >= x and mx <= x + w and my >= y and my <= y + h then
        love.graphics.setColor(highlightColor)
        love.graphics.rectangle("fill", x, y, w, h) 
        love.graphics.setColor(1, 1, 1) -- Reset color to default (white)
        if love.mouse.isDown(1) and fn then
            if params == false then fn() elseif params then fn(params) end
        end
    end
    
    love.graphics.setFont(font)
    love.graphics.setColor(textColor) -- Set color for text (black)
    love.graphics.print(text, labelx, labely)
    love.graphics.setColor(1, 1, 1) -- Reset color to default (white)
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
