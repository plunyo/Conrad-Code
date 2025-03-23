local AST = {}

AST.Type = {
    PROGRAM = "Program",
    NUMERIC_LITERAL = "NumericLiteral",
    NIL_LITERAL = "NilLiteral",
    IDENTIFIER = "Identifier",
    BINARY_EXPR = "BinaryExpression",
    UNARY_EXPR = "UnaryExpression",
    CALL_EXPR = "CallExpression",
    ASSIGNMENT_EXPR = "AssignmentExpression",
    BLOCK_STATEMENT = "BlockStatement",
    IF_STATEMENT = "IfStatement",
    WHILE_STATEMENT = "WhileStatement",
    RETURN_STATEMENT = "ReturnStatement",
}

local function indent(str, spaces)
    local padding = string.rep(" ", spaces or 2)
    return padding .. string.gsub(str, "\n", "\n" .. padding)
end

local function tableToString(tbl, level)
    level = level or 0
    local lines = {}
    for _, v in ipairs(tbl) do
        table.insert(lines, indent(tostring(v), (level + 1) * 2))
    end
    return table.concat(lines, ",\n")
end

-- base class for statements
local Statement = {}
Statement.__index = Statement

function Statement:new(kind)
    return setmetatable({ kind = kind }, self)
end

function Statement:__tostring()
    return string.format("Statement (Kind: %s)", tostring(self.kind))
end

-- program class (inherits from Statement)
local Program = {}
Program.__index = Program
setmetatable(Program, { __index = Statement })

function Program:new(body)
    return setmetatable({ kind = AST.Type.PROGRAM, body = body or {} }, self)
end

function Program:__tostring()
    local bodyStr = tableToString(self.body, 1)
    return string.format("Program {\n%s\n}", bodyStr)
end

-- base class for expressions
local Expr = {}
Expr.__index = Expr

function Expr:new(kind)
    return setmetatable({ kind = kind }, self)
end

function Expr:__tostring()
    return string.format("Expr (Kind: %s)", tostring(self.kind))
end

-- binary expression (inherits from Expr)
local BinaryExpr = {}
BinaryExpr.__index = BinaryExpr
setmetatable(BinaryExpr, { __index = Expr })

function BinaryExpr:new(left, right, operator)
    return setmetatable({
        kind = AST.Type.BINARY_EXPR,
        left = left,
        right = right,
        operator = operator,
    }, self)
end

function BinaryExpr:__tostring()
    return string.format(
        "BinaryExpr {\n%s,\n%s,\n%s\n}",
        indent("Left: " .. tostring(self.left), 4),
        indent("Operator: " .. tostring(self.operator), 4),
        indent("Right: " .. tostring(self.right), 4)
    )
end

-- identifier (inherits from Expr)
local Identifier = {}
Identifier.__index = Identifier
setmetatable(Identifier, { __index = Expr })

function Identifier:new(symbol)
    return setmetatable({ kind = AST.Type.IDENTIFIER, symbol = symbol }, self)
end

function Identifier:__tostring()
    return string.format("Identifier { Symbol: %s }", tostring(self.symbol))
end

-- numeric literal (inherits from Expr)
local NumericLiteral = {}
NumericLiteral.__index = NumericLiteral
setmetatable(NumericLiteral, { __index = Expr })

function NumericLiteral:new(value)
    return setmetatable(
        { kind = AST.Type.NUMERIC_LITERAL, value = value },
        self
    )
end

function NumericLiteral:__tostring()
    return string.format("NumericLiteral { Value: %s }", tostring(self.value))
end

-- nil literal (inherits from Expr)
local NilLiteral = {}
NilLiteral.__index = NilLiteral
setmetatable(NilLiteral, { __index = Expr })

function NilLiteral:new()
    return setmetatable({ kind = AST.Type.NIL_LITERAL }, self)
end

function NilLiteral:__tostring()
    return "NilLiteral {}"
end

AST.Statement = Statement
AST.Program = Program
AST.Expr = Expr
AST.BinaryExpr = BinaryExpr
AST.Identifier = Identifier
AST.NumericLiteral = NumericLiteral
AST.NilLiteral = NilLiteral

return AST
