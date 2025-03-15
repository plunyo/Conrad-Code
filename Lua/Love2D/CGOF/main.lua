-- Infinite Game of Life with Camera Movement & Enhanced Features
-- This code comes with customizable tick rate, colors, grid visibility, and a bunch of new features.

local cellSize = 10 -- Size of each cell in pixels
local generation = 0 -- Generation counter
local grid = {} -- Dictionary for cells; key = "x,y", value = true if alive

local cameraX, cameraY = 0, 0 -- Camera position in cell units
local tickRate = 0.1 -- Seconds per generation update
local timeAccumulator = 0
local paused = false
local showGrid = true -- Toggle to show/hide grid
local cellColor = { 1, 1, 1 } -- Default color for live cells
local gridColor = { 0.5, 0.5, 0.5, 0.3 } -- Default color for grid lines

-- Helper functions to create a key from x and y coordinates
local function keyFromCoords(x, y)
    return x .. "," .. y
end

local function setCell(x, y, alive)
    grid[keyFromCoords(x, y)] = alive
end

local function getCell(x, y)
    return grid[keyFromCoords(x, y)] or false
end

-- Count live neighbors around (x,y)
local function countAliveNeighbors(x, y)
    local count = 0
    for dx = -1, 1 do
        for dy = -1, 1 do
            if not (dx == 0 and dy == 0) and getCell(x + dx, y + dy) then
                count = count + 1
            end
        end
    end
    return count
end

-- Update grid by checking live cells and their neighbors
local function updateGrid()
    local nextGrid = {}
    local cellsToCheck = {}

    -- For every live cell, add it and all its neighbors to the check set
    for key, alive in pairs(grid) do
        if alive then
            local commaPos = key:find(",")
            local x = tonumber(key:sub(1, commaPos - 1))
            local y = tonumber(key:sub(commaPos + 1))
            cellsToCheck[key] = { x = x, y = y }
            for dx = -1, 1 do
                for dy = -1, 1 do
                    cellsToCheck[keyFromCoords(x + dx, y + dy)] =
                        { x = x + dx, y = y + dy }
                end
            end
        end
    end

    -- Apply Conway's rules
    for key, pos in pairs(cellsToCheck) do
        local aliveNeighbors = countAliveNeighbors(pos.x, pos.y)
        if getCell(pos.x, pos.y) then
            if aliveNeighbors == 2 or aliveNeighbors == 3 then
                nextGrid[key] = true
            else
                nextGrid[key] = false
            end
        else
            if aliveNeighbors == 3 then
                nextGrid[key] = true
            end
        end
    end

    grid = nextGrid
    generation = generation + 1
end

local function countAliveCells()
    local count = 0
    for _, v in pairs(grid) do
        if v then
            count = count + 1
        end
    end
    return count
end

function love.load()
    love.window.setTitle("Conrad's Game of Life")
    love.window.setMode(800, 600)
    love.graphics.setFont(love.graphics.newFont(14))

    -- Initialize grid with random live cells in a region (from -50 to 50 in both directions)
    for x = -50, 50 do
        for y = -50, 50 do
            if math.random() < 0.15 then -- 15% chance cell is alive
                setCell(x, y, true)
            end
        end
    end
end

function love.update(dt)
    -- Quit if you wanna bail out of the madness
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- Adjust tick rate based on keys pressed
    if love.keyboard.isDown("up") then
        tickRate = math.max(0.01, tickRate - 0.01) -- Speed up
    elseif love.keyboard.isDown("down") then
        tickRate = tickRate + 0.01 -- Slow down
    end

    -- Update simulation if not paused
    if not paused then
        timeAccumulator = timeAccumulator + dt
        while timeAccumulator >= tickRate do
            updateGrid()
            timeAccumulator = timeAccumulator - tickRate
        end
    end

    -- Smooth camera movement with arrow keys (move 10 cells per second)
    local camSpeed = 10 * dt
    if love.keyboard.isDown("w") then
        cameraY = cameraY - camSpeed
    end
    if love.keyboard.isDown("s") then
        cameraY = cameraY + camSpeed
    end
    if love.keyboard.isDown("a") then
        cameraX = cameraX - camSpeed
    end
    if love.keyboard.isDown("d") then
        cameraX = cameraX + camSpeed
    end
end

function love.draw()
    love.graphics.push()
    -- Translate world coordinates by camera offset (convert cell units to pixels)
    love.graphics.translate(-cameraX * cellSize, -cameraY * cellSize)

    -- Draw live cells as specified color
    love.graphics.setColor(cellColor)
    for key, alive in pairs(grid) do
        if alive then
            local commaPos = key:find(",")
            local x = tonumber(key:sub(1, commaPos - 1))
            local y = tonumber(key:sub(commaPos + 1))
            love.graphics.rectangle(
                "fill",
                x * cellSize,
                y * cellSize,
                cellSize,
                cellSize
            )
        end
    end
    love.graphics.pop()

    -- Draw grid overlay if enabled
    if showGrid then
        love.graphics.setColor(gridColor)
        local width, height = love.graphics.getDimensions()
        for i = 0, math.ceil(width / cellSize) do
            love.graphics.line(
                i * cellSize - (cameraX * cellSize) % cellSize,
                0,
                i * cellSize - (cameraX * cellSize) % cellSize,
                height
            )
        end
        for j = 0, math.ceil(height / cellSize) do
            love.graphics.line(
                0,
                j * cellSize - (cameraY * cellSize) % cellSize,
                width,
                j * cellSize - (cameraY * cellSize) % cellSize
            )
        end
    end

    -- Display info text (generation count, alive cells, camera pos, tick rate)
    love.graphics.setColor(1, 1, 1)
    local info = string.format(
        "Generation: %d    Alive Cells: %d    Camera: (%.2f, %.2f)    Tick Rate: %.2f    [Space to pause]    [WASD to move]",
        generation,
        countAliveCells(),
        cameraX,
        cameraY,
        tickRate
    )
    love.graphics.print(info, 10, 10)
end

function love.keypressed(key)
    if key == "space" then
        paused = not paused
    elseif key == "g" then
        showGrid = not showGrid -- Toggle grid visibility
    elseif key == "c" then
        -- Clear the grid (for when you want to start fresh)
        grid = {}
        generation = 0
    elseif key == "r" then
        -- Re-randomize the grid
        grid = {}
        generation = 0
        for x = -50, 50 do
            for y = -50, 50 do
                if math.random() < 0.15 then
                    setCell(x, y, true)
                end
            end
        end
    elseif key == "1" then
        cellColor = { 1, 0, 0 } -- Red
    elseif key == "2" then
        cellColor = { 0, 1, 0 } -- Green
    elseif key == "3" then
        cellColor = { 0, 0, 1 } -- Blue
    elseif key == "4" then
        cellColor = { 1, 1, 0 } -- Yellow
    elseif key == "5" then
        cellColor = { 1, 0.5, 0 } -- Orange
    elseif key == "6" then
        cellColor = { 1, 1, 1 } -- White (default)
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- Convert screen coordinates to world cell coordinates
        local worldX = math.floor((x + cameraX * cellSize) / cellSize)
        local worldY = math.floor((y + cameraY * cellSize) / cellSize)
        -- Toggle the cell state
        setCell(worldX, worldY, not getCell(worldX, worldY))
    end
end
