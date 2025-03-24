local Environment = {}
Environment.__index = Environment

function Environment:new(parentEnv)
    return setmetatable({
        parent = parentEnv,
        variables = {},
    }, self)
end

function Environment:declareVar(varName, value)
    if self.variables[varName] then
        error(
            string.format(
                'Cannot declare variable "%s". Already defined',
                varName
            )
        )
    end

    self.variables[varName] = value
    return value
end

function Environment:resolve(varName)
    if self.variables[varName] then
        return self
    end

    if self.parent == nil then
        error(
            string.format('Cannot resolve "%s" as it does not exist', varName)
        )
    end

    return self.parent:resolve(varName)
end

function Environment:lookupVar(varName)
    local env = self:resolve(varName)
    return env.variables[varName] -- note: this is fine as is; just make sure 'varName' is resolved correctly
end

function Environment:assignVar(varName, value)
    local env = self:resolve(varName)
    env.variables[varName] = value
    return value
end

return Environment
