local Signal = { callbacks = {} }
Signal.__index = Signal

function Signal:new()
    local instance = setmetatable({}, Signal)

    instance.callbacks = {}

    return instance
end

function Signal:connect(callback)
    table.insert(self.callbacks, callback)
end

function Signal:emit(...)
    for _, callback in pairs(self.callbacks) do
        callback(...)
    end
end

return Signal
