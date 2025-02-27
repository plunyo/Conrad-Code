from typing import List, Optional
from enum import Enum


class NodeType(Enum):
    # Statements
    Program = "Program"
    VarDeclaration = "VariableDeclaration"
    
    # Expressions
    AssignmentExpression = "AssignmentExpression"
    BinaryExpression = "BinaryExpression"
    MemberExpression = "MemberExpression"
    CallExpression = "CallExpression"
    
    # Literals
    ObjectLiteral = "ObjectLiteral"
    Property = "Property"
    NumericLiteral = "NumericLiteral"
    Identifier = "Identifier"


class Statement:
    def __init__(self, kind: NodeType):
        self.kind: NodeType = kind

    def __repr__(self):
        return f"{self.__class__.__name__}( kind = {self.kind} )"

class Program(Statement):
    def __init__(self, body: List[Statement]):
        super().__init__(NodeType.Program)
        self.body: List[Statement] = body

    def __repr__(self):
        body_repr = ", ".join(repr(statement) for statement in self.body)
        return f"{self.__class__.__name__}( body = [ {body_repr} ] )"

class Expression(Statement):
    def __init__(self, kind: NodeType):
        super().__init__(kind)

    def __repr__(self):
        return f"{self.__class__.__name__}( kind = {self.kind} )"

class AssignmentExpression(Expression):
    def __init__(self, assignee: Expression, value: Expression):
        super().__init__(NodeType.AssignmentExpression)
        self.asignee = assignee
        self.value = value
    
    def __repr__(self):
        return f"{self.__class__.__name__}( asignee = {self.asignee} value = {self.value} )"

class VarDeclaration(Statement):
    def __init__(self, constant: bool, name: str, value: Optional[Expression] = None):
        super().__init__(NodeType.VarDeclaration)
        self.constant = constant
        self.name = name
        self.value = value
        
    def __repr__(self):
        return f"{self.__class__.__name__}( constant = {self.constant}, name = {self.name}, value = {self.value} )"

class BinaryExpression(Expression):
    def __init__(self, left: Expression, operator: str, right: Expression):
        super().__init__(NodeType.BinaryExpression)
        self.left: Expression = left
        self.operator: str = operator
        self.right: Expression = right

    def __repr__(self):
        return (f"{self.__class__.__name__}( "
                f"left = {repr(self.left)}, "
                f"operator = '{self.operator}', "
                f"right = {repr(self.right)})")

class CallExpression(Expression):
    def __init__(self, args: List[Expression], caller: Expression):
        super().__init__(NodeType.CallExpression)
        self.args = args
        self.caller = caller
    
    def __repr__(self):
        return f"{self.__class__.__name__}( args = {self.args}, caller = {self.caller})"
    
class MemberExpression(Expression):
    def __init__(self, object: Expression, property: Expression, computed: bool):
        super().__init__(NodeType.MemberExpression)
        self.object = object
        self.property = property
        self.computed = computed

class Identifier(Expression):
    def __init__(self, name: str):
        super().__init__(NodeType.Identifier)
        self.name: str = name

    def __repr__(self):
        return f"{self.__class__.__name__} ( name = '{self.name}' )"

class NumericLiteral(Expression):
    def __init__(self, value: str):
        super().__init__(NodeType.NumericLiteral)
        self.value: str = value

    def __repr__(self):
        return f"{self.__class__.__name__} ( value = '{self.value}' )"

class Property(Expression):
    def __init__(self, key: str, value: Expression | None):
        super().__init__(NodeType.Property)
        self.key = key,
        self.value = value

class ObjectLiteral(Expression):
    def __init__(self, properties: List[Property]):
        super().__init__(NodeType.ObjectLiteral)
        self.properties = properties

    def __repr__(self):
        return f"{self.__class__.__name__}( properties = '{self.properties}' )"

