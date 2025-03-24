local Values = require("runtime.values")
local AST = require("frontend.ast")

local Interpreter = {}

function Interpreter:evalProgram(program, env)
    local lastEvaluated = Values.NilVal:new()

    for _, statement in ipairs(program.body) do
        lastEvaluated = self:evaluate(statement, env)
    end

    return lastEvaluated
end

function Interpreter.evalNumericBinaryExpr(lhs, rhs, operator)
    local result = 0

    if operator == "+" then
        result = lhs.value + rhs.value
    elseif operator == "-" then
        result = lhs.value - rhs.value
    elseif operator == "*" then
        result = lhs.value * rhs.value
    elseif operator == "/" then
        if rhs.value == 0 then
            error("Division by 0.")
        end
        result = lhs.value / rhs.value
    elseif operator == "%" then
        result = lhs.value % rhs.value
    end

    return Values.NumberVal:new(result)
end

function Interpreter:evalBinaryExpr(binOp, env)
    local lhs = self:evaluate(binOp.left, env)
    local rhs = self:evaluate(binOp.right, env)

    if
        lhs.type == Values.ValueType.NUMBER
        and rhs.type == Values.ValueType.NUMBER
    then
        return self.evalNumericBinaryExpr(lhs, rhs, binOp.operator)
    end

    -- one or both are nil or unsupported types
    return Values.NilVal:new()
end

function Interpreter:evalIdentifier(identifier, env)
    local value = env:lookupVar(identifier.symbol)
    return value
end

function Interpreter:evaluate(astNode, env)
    local astNodeKind = astNode.kind

    if astNodeKind == AST.Type.NUMERIC_LITERAL then
        return Values.NumberVal:new(astNode.value)
    elseif astNodeKind == AST.Type.IDENTIFIER then
        return self:evalIdentifier(astNode, env)
    elseif astNodeKind == AST.Type.BINARY_EXPR then
        return self:evalBinaryExpr(astNode, env)
    elseif astNodeKind == AST.Type.PROGRAM then
        return self:evalProgram(astNode, env)
    else
        error(
            string.format(
                "This AST node hasn't been set up for interpretation.\n%s",
                astNode
            )
        )
    end
end

return Interpreter
