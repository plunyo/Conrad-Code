from enum import Enum
from typing import List, Dict

DIGITS: str = '0123456789'
LETTERS: str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'

class TokenType(Enum):
    # Literal Types
    Number = "Number"
    Identifier = "Identifier"
    
    # Keywords
    Set = "Set"
    Const = "Const"
    
    # Grouping & Operators
    BinaryOperator = "BinaryOperator"
    Equals = "Equals"
    Comma = ","
    Dot = "."
    Colon = ":"
    Semicolon = "Semicolon"
    
    L_Paren = "("
    R_Paren = ")"
    
    L_Brace = "{"
    R_Brace = "}"
    
    L_Bracket = '['
    R_Bracket = ']'

    EOF = "End Of File"
    
KEYWORDS: Dict[str, TokenType] = {
    "set": TokenType.Set,
    "const": TokenType.Const
}

class Token:
    def __init__(self, type: TokenType, value: str = ""):
        self.type: TokenType = type
        self.value: str = value

    def __repr__(self) -> str:
        return f"[ {self.type} : '{self.value}' ]"

def tokenize(source_code: str) -> List[Token]:
    tokens: List[Token] = []
    src: List[str] = list(source_code)

    while src:
        char: str = src.pop(0)

        if char.isspace(): 
            continue
        
        if char in '()+-*/%=^;}{:,][.':
            tokens.append(Token({
                '(': TokenType.L_Paren, 
                ')': TokenType.R_Paren,
                
                '{': TokenType.L_Brace,
                '}': TokenType.R_Brace,
                
                '[': TokenType.L_Bracket,
                ']': TokenType.R_Bracket,
                
                '=': TokenType.Equals,
                ';': TokenType.Semicolon,
                ':': TokenType.Colon,
                ',': TokenType.Comma,
                '.': TokenType.Dot,
                
                '+': TokenType.BinaryOperator,
                '-': TokenType.BinaryOperator, 
                '*': TokenType.BinaryOperator,
                '/': TokenType.BinaryOperator, 
                '%': TokenType.BinaryOperator,
                '^': TokenType.BinaryOperator
            }[char], char))
            
            
            # multichar tokens from here on out
        elif char in DIGITS:
            num: str = char
            while src and src[0] in DIGITS:
                num += src.pop(0)
            tokens.append(Token(TokenType.Number, float(num)))
        elif char in LETTERS:
            identifier: str = char
            while src and src[0] in LETTERS + DIGITS:
                identifier += src.pop(0)
                
            reserved: TokenType = KEYWORDS.get(identifier, None)
            tokens.append(Token(reserved if reserved is not None else TokenType.Identifier, identifier))
        else:
            raise ValueError(f"Unrecognized token: {char}")

    tokens.append(Token(TokenType.EOF))
    return tokens

