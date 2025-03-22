game = require('src.game')

map = {}

function map.colliders()
    walls = {}
    if game.map.layers["walls"] then
        for i, obj in pairs(game.map.layers["walls"].objects) do
            if obj.width > 0 and obj.height > 0 then
                local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                wall:setType('static')
                table.insert(walls, wall)
            else
                print("Warning: Invalid rectangle dimensions for collider at index " .. i)
            end
        end
    end
end

return map