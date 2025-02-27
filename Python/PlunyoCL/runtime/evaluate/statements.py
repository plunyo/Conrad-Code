from frontend.ast_nodes import *
from runtime.environment import Environment
from runtime.values import *
from runtime import interpreter

def evaluate_program(program: Program, env: Environment) -> RuntimeValue:
    last_evaluated: RuntimeValue = NilVal()
    
    for statement in program.body:
        last_evaluated = interpreter.evaluate(statement, env)
    
    return last_evaluated

def evaluate_variable_declaration(declaration: VarDeclaration, env: Environment) -> RuntimeValue:
    value = interpreter.evaluate(declaration.value, env) if declaration.value else NilVal()
    env.declare_variable(declaration.name, value, declaration.constant)
    return value
