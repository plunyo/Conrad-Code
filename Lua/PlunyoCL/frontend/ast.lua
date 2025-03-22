local AST = {}

-- define node types inside AST
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

    -- declarations
    FUNCTION_DECLARATION = "FunctionDeclaration", -- function fn() {}
    VARIABLE_DECLARATION = "VariableDeclaration", -- let x = 5;
}

-- base class for statements
local Statement = {}
Statement.__index = Statement

function Statement:new(kind)
    local instance = setmetatable({}, self)
    instance.kind = kind
    return instance
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

-- base class for expressions
local Expr = {}
Expr.__index = Expr

function Expr:new(kind)
    local instance = setmetatable({}, self)
    instance.kind = kind
    return instance
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

-- identifier (inherits from Expr)
local Identifier = {}
Identifier.__index = Identifier
setmetatable(Identifier, { __index = Expr })

function Identifier:new(symbol)
    local instance = setmetatable(Expr:new(AST.Type.IDENTIFIER), self)
    instance.symbol = symbol
    return instance
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

-- blank literal (inherits from Expr)
local BlankLiteral = {}
BlankLiteral.__index = BlankLiteral
setmetatable(BlankLiteral, { __index = Expr })

function BlankLiteral:new()
    return setmetatable(Expr:new(AST.Type.BLANK_LITERAL), self)
end

-- register classes in AST
AST.NumericLiteral = NumericLiteral
AST.BlankLiteral = BlankLiteral
AST.BinaryExpr = BinaryExpr
AST.Identifier = Identifier
AST.Statement = Statement
AST.Program = Program
AST.Expr = Expr

return AST
