local Value = require("runtime.value")
local AST = require("frontend.ast")

local Interpreter = {}

function Interpreter:evalProgram(program)
    local lastEvaluated = Value.NilVal:new()

    for _, statement in ipairs(program) do
        lastEvaluated = evaluate(statement)
    end

    return lastEvaluated
end

function Interpreter:evalNumericBinaryExpr(lhs, rhs, operator)
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

    return Value.NumberVal:new(result)
end

function Interpreter:evalBinaryExpr(binOp)
    local leftSide = self:evaluate(binOp.left)
    local rightSide = self:evaluate(binOp.right)

    if
        lhs.type == Value.ValueType.NUMBER
        and rhs.type == Value.ValueType.NUMBER
    then
        return self:evalNumericBinaryExpr(lhs, rhs, binOp.operator)
    end

    -- 1 or both r nil
    return Value.NilVal:new()
end

function Interpreter:evaluate(astNode)
    local astNodeKind = astNode.kind

    if astNodeKind == AST.Type.NUMERIC_LITERAL then
        return Value.NumberVal:new(astNode.value)
    elseif astNodeKind == AST.Type.NIL_LITERAL then
        return Value.NilVal:new()
    elseif astNodeKind == AST.Type.BINARY_EXPR then
        return self:evalBinaryExpr(astNode)
    elseif astNodeKind == AST.Type.BINARY_EXPR then
        return self:evalProgram(astNode)
    else
        error("This AST Node has not yet been setup for interpretation.")
    end
end

return Interpreter
