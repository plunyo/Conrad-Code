from frontend.ast_nodes import *
from runtime.environment import Environment
from runtime.values import *
from runtime import interpreter

def evaluate_numeric_binary_expression(lhs: NumberVal, rhs: NumberVal, operator: str) -> NumberVal:
    result: float = 0
    
    match operator:
        case "+":
            result = lhs.value + rhs.value
        case "-":
            result = lhs.value - rhs.value
        case "*":
            result = lhs.value * rhs.value
        case "/":
            if rhs.value == 0:
                raise ZeroDivisionError("Yo, what are you trying to do? Divide by zero? 🤦‍♂️ Not happening, fam.")
            result = lhs.value / rhs.value
        case "%":
            result = lhs.value % rhs.value
        case "^":
            result = lhs.value ** rhs.value
    
    return NumberVal(result)

def evaluate_binary_expression(bin_op: BinaryExpression, env: Environment) -> RuntimeValue:
    lhs = interpreter.evaluate(bin_op.left, env)
    rhs = interpreter.evaluate(bin_op.right, env)
    
    if isinstance(lhs, NumberVal) and isinstance(rhs, NumberVal):
        return evaluate_numeric_binary_expression(lhs, rhs, bin_op.operator)
    
    # 1 or both are nil
    return NilVal()

def evaluate_identifier(ident: Identifier, env: Environment) -> RuntimeValue:
    val = env.lookup_variable(ident.name)
    return val

def evaluate_assignment(node: AssignmentExpression, env: Environment) -> RuntimeValue:
    if node.asignee.kind != NodeType.Identifier:
        raise SyntaxError("Invalid LHS inside assignment expression", node.asignee)
    
    var_name = node.asignee.name
    value = interpreter.evaluate(node.value, env)
    env.assign_variable(var_name, value)
    return value

def evaluate_object_expression(obj: ObjectLiteral, env: Environment) -> RuntimeValue:
    object = ObjectVal({})
    
    # handells valid key-value pair
    for property in obj.properties:
        # (property.key | property.value) for the key and value
        
        runtime_val = env.lookup_variable(property.key) if property.value == None else interpreter.evaluate(property.value, env)
        
        object.properties[property.key] = runtime_val

    return object