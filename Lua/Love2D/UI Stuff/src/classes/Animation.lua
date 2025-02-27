local Animation = {}
Animation.__index = Animation

function Animation:new(spriteSheet, frames, frameDelay, loop, scale)
    local instance = setmetatable({}, Animation)

    instance.spriteSheet = spriteSheet
    instance.frames = frames or {}
    instance.frameDelay = frameDelay or 0.1
    instance.loop = loop or false
    instance.playing = false
    instance.elapsedTime = 0
    instance.currentFrame = 1
    instance.scale = scale or 1

    return instance
end

function Animation:update(dt)
    if not self.playing or #self.frames == 0 then return end

    self.elapsedTime = self.elapsedTime + dt
    if self.elapsedTime >= self.frameDelay then
        self.elapsedTime = self.elapsedTime - self.frameDelay
        self.currentFrame = self.currentFrame + 1

        if self.currentFrame > #self.frames then
            if self.loop then
                self.currentFrame = 1
            else
                self.currentFrame = #self.frames
                self:stop()
            end
        end
    end
end

function Animation:draw(x, y)
    if #self.frames == 0 or not self.currentFrame then return end
    local frame = self.frames[self.currentFrame]
    love.graphics.draw(self.spriteSheet, frame, x, y, 0, self.scale, self.scale)
end

function Animation:play()
    if #self.frames > 0 then
        self.playing = true
        self.currentFrame = 1
        self.elapsedTime = 0
    end
end

function Animation:stop()
    self.playing = false
end

function Animation:isPlaying()
    return self.playing
end

function Animation:setScale(scale)
    self.scale = scale
end

return Animation
