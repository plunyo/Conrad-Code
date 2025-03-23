local Value = {}

Value.ValueType = {
    NULL = "Null",
    NUMBER = "Number",
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
    return setmetatable({ type = Value.ValueType.NULL, value = "nil" }, self)
end

function NilVal:__tostring()
    return "NilVal { value = nil }"
end

local NumberVal = {}
NumberVal.__index = NumberVal
setmetatable(NumberVal, { __index = RuntimeVal })

function NumberVal:new(number)
    return setmetatable({ type = Value.ValueType.NUMBER, value = number }, self)
end

function NumberVal:__tostring()
    return string.format("NumberVal { value = %s }", tostring(self.value))
end

Value.RuntimeVal = RuntimeVal
Value.NilVal = NilVal
Value.NumberVal = NumberVal

return Value
