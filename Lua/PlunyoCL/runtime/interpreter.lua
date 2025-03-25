local Values = require("runtime.values")
local AST = require("frontend.ast")

local Interpreter = {}

function Interpreter:evalProgram(program, env)
    local lastVal = Values.NilVal:new()

    for _, stmt in ipairs(program.body) do
        lastVal = self:evaluate(stmt, env)
    end

    return lastVal
end

function Interpreter:evalVarDeclaration(declaration, env)
    local value = declaration.value and self:evaluate(declaration.value, env)
        or Values.NilVal:new()
    return env:declareVar(declaration.identifier, value)
end

function Interpreter:evalBinaryExpr(binOp, env)
    local lhs, rhs =
        self:evaluate(binOp.left, env), self:evaluate(binOp.right, env)

    local op, result = binOp.operator, 0

    if
        lhs.type == Values.ValueType.NUMBER
        and rhs.type == Values.ValueType.NUMBER
    then
        if op == "+" then
            result = lhs.value + rhs.value
        elseif op == "-" then
            result = lhs.value - rhs.value
        elseif op == "*" then
            result = lhs.value * rhs.value
        elseif op == "/" then
            if rhs.value == 0 then
                error("Division by 0.")
            end

            result = lhs.value / rhs.value
        elseif op == "%" then
            result = lhs.value % rhs.value
        end
        return Values.NumberVal:new(result)
    end

    return Values.NilVal:new()
end

function Interpreter:evaluate(astNode, env)
    local kind = astNode.kind

    if kind == AST.Type.NUMERIC_LITERAL then
        return Values.NumberVal:new(astNode.value)
    elseif kind == AST.Type.IDENTIFIER then
        return env:lookupVar(astNode.symbol)
    elseif kind == AST.Type.BINARY_EXPR then
        return self:evalBinaryExpr(astNode, env)
    elseif kind == AST.Type.PROGRAM then
        return self:evalProgram(astNode, env)
    elseif kind == AST.Type.VAR_DECLARATION then
        return self:evalVarDeclaration(astNode, env)
    else
        error("Unhandled AST node: " .. tostring(kind))
    end
end

return Interpreter
