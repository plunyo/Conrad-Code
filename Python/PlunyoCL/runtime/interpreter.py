from runtime.values import *
from runtime.environment import Environment
from frontend.ast_nodes import *
from runtime.evaluate.expression import evaluate_identifier, evaluate_binary_expression, evaluate_assignment, evaluate_object_expression
from runtime.evaluate.statements import evaluate_program, evaluate_variable_declaration

def evaluate(ast_node: Statement, env: Environment) -> RuntimeValue:
    match ast_node.kind:
        case NodeType.NumericLiteral:
            return NumberVal(ast_node.value)
        case NodeType.Identifier:
            return evaluate_identifier(ast_node, env)
        case NodeType.ObjectLiteral:
            return evaluate_object_expression(ast_node, env)
        case NodeType.BinaryExpression:
            return evaluate_binary_expression(ast_node, env)
        case NodeType.AssignmentExpression:
            return evaluate_assignment(ast_node, env)
        case NodeType.Program:
            return evaluate_program(ast_node, env)
        # handle statements
        case NodeType.VarDeclaration:
            return evaluate_variable_declaration(ast_node, env)
        case _:
            raise NotImplementedError(f"AST node {repr(ast_node)} not yet implemented.")
