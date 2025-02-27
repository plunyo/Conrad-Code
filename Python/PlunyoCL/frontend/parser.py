from frontend.ast_nodes import *
from typing import List
from frontend.lexer import tokenize, Token, TokenType

class Parser:
    def __init__(self):
        self.tokens: List[Token] = []
        self.index: int = 0

    def at(self) -> Token:
        return self.tokens[self.index]

    def eat(self) -> Token:
        at = self.at()
        self.index += 1
        return at

    def expect(self, type: TokenType, err: str) -> Token:
        prev = self.eat()
        if prev.type != type:
            raise SyntaxError(f"Parser Error:\n{err} {prev} - Expecting: {type}")

        return prev

    def generate_ast(self, source_code: str) -> Program:
        self.index = 0
        self.tokens = tokenize(source_code)
        program = Program([])

        while self.at().type != TokenType.EOF:
            program.body.append(self.parse_statement())

        return program

    def parse_statement(self) -> Statement:
        match self.at().type:
            case TokenType.Set:
                return self.parse_variable_declaration()
            case TokenType.Const:
                return self.parse_variable_declaration()
            case _:
                return self.parse_expression()
    
    # "const" or "set"
    def parse_variable_declaration(self) -> Statement:
        is_constant = self.eat().type == TokenType.Const  # Check if it's a constant
        name = self.expect(TokenType.Identifier, "Expected identifier name following (set | const) keywords").value

        if self.at().type == TokenType.Semicolon:
            self.eat()  # Expect semicolon

            if is_constant:
                raise ValueError(f"Must assign a value to constant '{name}'. No value provided.")
            
            return VarDeclaration(False, name)

        self.expect(TokenType.Equals, "Expected equals after identifier in var declaration.")

        value_expression = self.parse_expression()
        
        return VarDeclaration(is_constant, name, value_expression)

    def parse_expression(self) -> Expression:
        return self.parse_assignment_expression()
    
    def parse_assignment_expression(self):
        left = self.parse_object_expression() # switch with objects
        
        if self.at().type == TokenType.Equals:
            self.eat() # advance past equalds
            value = self.parse_assignment_expression()
            return AssignmentExpression(left, value)
        
        return left

    def parse_object_expression(self) -> Expression:
        if self.at().type != TokenType.L_Brace:
            return self.parse_additive_expression()
        
        self.eat()  # advance past open brace
        properties: List[Property] = []
        
        while self.at().type != TokenType.EOF and self.at().type != TokenType.R_Brace:
            key = self.expect(TokenType.Identifier, "Object literal key expected").value
            
            # allow shorthand so instead of {key : value} can do {key,}
            if self.at().type == TokenType.Comma:
                self.eat()  # go past comma
                properties.append(Property(key))
                continue
            # allow shorthand so instead of {key : value} can do {key}
            elif self.at().type == TokenType.R_Brace:
                properties.append(Property(key))
                continue
            
            # allow normal so {key : value}
            self.expect(TokenType.Equals, "Missing equals sign following identifier in ObjectExpression")
            value = self.parse_expression()
            
            properties.append(Property(key, value))
            
            if self.at().type != TokenType.R_Brace:
                self.expect(TokenType.Comma, "Expected comma or closing brace following property.")
            
        self.expect(TokenType.R_Brace, "Object literal missing closing brace")
        return ObjectLiteral(properties)
        
    
    def parse_additive_expression(self) -> Expression:
        left = self.parse_multiplicative_expression()

        while (op := self.at().value) in ("+", "-", "^"):
            self.eat()
            right = self.parse_multiplicative_expression()
            left = BinaryExpression(left, op, right)

        return left

    def parse_multiplicative_expression(self) -> Expression:
        left = self.parse_call_member_expression()

        while (op := self.at().value) in ("*", "/", "%"):
            self.eat()
            right = self.parse_call_member_expression()
            left = BinaryExpression(left, op, right)

        return left
    
    def parse_call_member_expression(self) -> Expression:
        member = self.parse_member_expression()
        
        if self.at().type == TokenType.L_Paren:
            return self.parse_call_expression(member)
        
        return member
    
    def parse_call_expression(self, caller: Expression) -> Expression:
        call_expression: CallExpression = CallExpression(caller, self.parse_args())
        
        if self.at().type == TokenType.L_Paren:
            call_expression = self.parse_call_expression(call_expression)
            
        return call_expression
    
    def parse_args(self) -> List[Expression]:
        self.expect(TokenType.L_Paren, "Expected open parenthesis, also, how????.")
        args = [] if self.at().type == TokenType.R_Paren else self.parse_arguments_list()
        
        self.expect(TokenType.R_Paren, "Missing closing parenthesis inside arguments list")
        return args

    def parse_arguments_list(self) -> List[Expression]:
        args = [self.parse_assignment_expression()]
        
        while self.at().type == TokenType.Comma and self.eat():
            args.append(self.parse_assignment_expression())
        
        return args
    
    def parse_member_expression(self) -> Expression:
        object = self.parse_primary_expression()
        
        while self.at().type == TokenType.Dot or self.at().type == TokenType.L_Bracket:
            operator = self.eat()
            property: Expression
            computed: bool
            
            # non-computed values
            if operator.type == TokenType.Dot:
                computed = False
                property = self.parse_primary_expression()
                
                if property.kind != NodeType.Identifier:
                    raise AttributeError("Cannot use dot operator without right hand side being an identifier.")
            else: # allows obj[computed_value]
                computed = True
                property = self.parse_expression()
                
                self.expect(TokenType.R_Bracket, "Missing closing bracket in computed value.")
            
            object = MemberExpression(object, property, computed)
        
        return object


    def parse_primary_expression(self) -> Expression:
        match self.at().type:
            case TokenType.L_Paren:
                self.eat()
                value = self.parse_expression()
                self.expect(TokenType.R_Paren, "Unexpected token found inside parenthesized expression. Expected closing parenthesis.")
                return value
            case TokenType.Identifier:
                return Identifier(self.eat().value)
            case TokenType.Number:
                return NumericLiteral(self.eat().value)
            case _:
                raise SyntaxError(f"Unexpected Token found during parsing: '{self.at()}'")