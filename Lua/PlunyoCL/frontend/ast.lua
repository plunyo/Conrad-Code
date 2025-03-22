local AST = {}

AST.Type = {
    -- top-level program node
    PROGRAM = "Program",

    -- literals (basic values)
    NUMERIC_LITERAL = "NumericLiteral", -- numbers like 42, 3.14
    BLANK_LITERAL = "BlankLiteral", -- for "null", "nil", or similar
    IDENTIFIER = "Identifier", -- variable or function names

    -- expressions
    BINARY_EXPR = "BinaryExpression", -- math/logic like x + y, a && b
    UNARY_EXPR = "UnaryExpression", -- single-operand like -x, !x
    CALL_EXPR = "CallExpression", -- function calls like foo(1, 2, 3)
    ASSIGNMENT_EXPR = "AssignmentExpression", -- assigning values, e.g., x = 10

    -- statements
    BLOCK_STATEMENT = "BlockStatement", -- code blocks: { ... }
    IF_STATEMENT = "IfStatement", -- if (condition) { ... }
    WHILE_STATEMENT = "WhileStatement", -- while loops
    RETURN_STATEMENT = "ReturnStatement", -- return x;
}

-- helper function for indentation
local function indent(str, spaces)
    local padding = string.rep(" ", spaces or 2)
    return padding .. string.gsub(str, "\n", "\n" .. padding)
end

-- helper function to convert table of items to string with indentation
local function tableToString(tbl, level)
    level = level or 0
    local lines = {}
    for _, v in ipairs(tbl) do
        local str = tostring(v)
        table.insert(lines, indent(str, (level + 1) * 2))
    end
    return table.concat(lines, ",\n")
end

-- base class for statements
local Statement = {}
Statement.__index = Statement

function Statement:new(kind)
    local instance = setmetatable({}, self)
    instance.kind = kind
    return instance
end

function Statement:__tostring()
    return string.format("Statement (Kind: %s)", tostring(self.kind))
end

-- program class (inherits from Statement)
local Program = {}
Program.__index = Program
setmetatable(Program, { __index = Statement })

function Program:new(body)
    local instance = setmetatable(Statement:new(AST.Type.PROGRAM), self)
    instance.body = body or {}
    return instance
end

function Program:__tostring()
    local bodyStr = tableToString(self.body, 1)
    return string.format("Program {\n%s\n}", bodyStr)
end

-- base class for expressions
local Expr = {}
Expr.__index = Expr

function Expr:new(kind)
    local instance = setmetatable({}, self)
    instance.kind = kind
    return instance
end

function Expr:__tostring()
    return string.format("Expr (Kind: %s)", tostring(self.kind))
end

-- binary expression (inherits from Expr)
local BinaryExpr = {}
BinaryExpr.__index = BinaryExpr
setmetatable(BinaryExpr, { __index = Expr })

function BinaryExpr:new(left, right, operator)
    local instance = setmetatable(Expr:new(AST.Type.BINARY_EXPR), self)
    instance.left = left
    instance.right = right
    instance.operator = operator
    return instance
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
    local instance = setmetatable(Expr:new(AST.Type.IDENTIFIER), self)
    instance.symbol = symbol
    return instance
end

function Identifier:__tostring()
    return string.format("Identifier { Symbol: %s }", tostring(self.symbol))
end

-- numeric literal (inherits from Expr)
local NumericLiteral = {}
NumericLiteral.__index = NumericLiteral
setmetatable(NumericLiteral, { __index = Expr })

function NumericLiteral:new(value)
    local instance = setmetatable(Expr:new(AST.Type.NUMERIC_LITERAL), self)
    instance.value = value
    return instance
end

function NumericLiteral:__tostring()
    return string.format("NumericLiteral { Value: %s }", tostring(self.value))
end

-- blank literal (inherits from Expr)
local BlankLiteral = {}
BlankLiteral.__index = BlankLiteral
setmetatable(BlankLiteral, { __index = Expr })

function BlankLiteral:new()
    return setmetatable(Expr:new(AST.Type.BLANK_LITERAL), self)
end

function BlankLiteral:__tostring()
    return "BlankLiteral {}"
end

-- register classes in AST (if needed)
AST.Statement = Statement
AST.Program = Program
AST.Expr = Expr
AST.BinaryExpr = BinaryExpr
AST.Identifier = Identifier
AST.NumericLiteral = NumericLiteral
AST.BlankLiteral = BlankLiteral

return AST
