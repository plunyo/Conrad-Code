local saves = {}

function saves.create(filename)
    data = {}
    data.fileUsed = false

    local folder = "saves"
    local path = love.filesystem.getSaveDirectory() .. "/" .. folder .. "/" .. filename .. 'txt'
    local success, message = love.filesystem.createDirectory(folder)
    if success then
        success, message = love.filesystem.write(path, "")
        if success then
            print("File created: " .. path)
            game.save = filename
        else
            print("Failed to create file: " .. message)
        end
    else
        print("Failed to create folder: " .. message)
    end
end

return saves
