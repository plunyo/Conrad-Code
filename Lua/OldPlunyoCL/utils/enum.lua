local Enum = {}
Enum.__index = Enum

-- Constructor for creating a new Enum
function Enum.new(names)
    local self = setmetatable({}, Enum)

    self.values = {}
    self.names = {}
    self.size = 0

    local currentValue = 1

    for _, name in ipairs(names) do
        if self.values[name] then
            error("Enum name must be unique")
        end

        self.values[name] = currentValue
        self.names[currentValue] = name
        self[name] = currentValue
        self.size = self.size + 1

        currentValue = currentValue + 1
    end

    return self
end

function Enum:getValue(name)
    return self.values[name]
end

function Enum:getName(value)
    return self.names[value]
end

function Enum:hasValue(value)
    return self.names[value] ~= nil
end

function Enum:__tostring()
    local elements = {}

    for name, value in pairs(self.values) do
        table.insert(elements, string.format("%s = %s", name, tostring(value)))
    end

    return "Enum {" .. table.concat(elements, ", ") .. "}"
end

return Enum
