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

function Interpreter:evalBinaryExpr(binOp)
    -- THIS IS WHERE YOU ARE UP TO CONRAD DONT FORGET YOU STUPID P.O.S, EP: WALKING THE AST (TIMESTAMP: 17:09)
end

function Interpreter:evaluate(astNode)
    local handler = ({
        [AST.Type.NUMERIC_LITERAL] = function()
            return Value.NumberVal:new(astNode.value)
        end,

        [AST.Type.NIL_LITERAL] = function()
            return Value.NilVal:new()
        end,

        [AST.Type.BINARY_EXPR] = function ()
            return self:evalBinaryExpr(astNode)
        end

        [AST.Type.BINARY_EXPR] = function ()
            return self:evalProgram(astNode)
        end
    })[astNode.kind]

    if handler then
        return handler()
    else
        error("This AST Node has not yet been setup for interpretation.")
    end
end

return Interpreter
