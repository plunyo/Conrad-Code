local Values = {}

Values.ValueType = {
    NULL = "Null",
    NUMBER = "Number",
    BOOL = "Bool",
}

local RuntimeVal = {}
RuntimeVal.__index = RuntimeVal

function RuntimeVal:new(type)
    return setmetatable({ type = type }, self)
end

function RuntimeVal:__tostring()
    return string.format("RuntimeVal { type = %s }", self.type)
end

local NilVal = {}
NilVal.__index = NilVal
setmetatable(NilVal, { __index = RuntimeVal })

function NilVal:new()
    return setmetatable({ type = Values.ValueType.NULL, value = "nil" }, self)
end

function NilVal.__tostring()
    return "NilVal { value = nil }"
end

local BoolVal = {}
BoolVal.__index = BoolVal
setmetatable(BoolVal, { __index = RuntimeVal })

function BoolVal:new(value)
    return setmetatable({ type = Values.ValueType.NULL, value = value }, self)
end

function BoolVal:__tostring()
    return string.format("BoolVal { value = %s }", self.value)
end
local NumberVal = {}
NumberVal.__index = NumberVal
setmetatable(NumberVal, { __index = RuntimeVal })

function NumberVal:new(number)
    return setmetatable(
        { type = Values.ValueType.NUMBER, value = number },
        self
    )
end

function NumberVal:__tostring()
    return string.format("NumberVal { value = %s }", tostring(self.value))
end

Values.RuntimeVal = RuntimeVal
Values.NilVal = NilVal
Values.BoolVal = BoolVal
Values.NumberVal = NumberVal

return Values
