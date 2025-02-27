from typing import Dict, Set
from runtime.values import *

class Environment():
    def __init__(self, parent = None):
        self.parent: Environment | None = parent
        self.variables: Dict[str, RuntimeValue] = {};
        self.constants: Set[str] = set()
        
        self.is_global_env: bool = False if self.parent is not None else True
        
        if self.is_global_env:
            setup_global_scope(self)
    
    def declare_variable(self, var_name: str, value: RuntimeValue, constant: bool = False) -> RuntimeValue:
        if var_name in self.variables:
            self.assign_variable(var_name, value)
            return
        
        self.variables[var_name] = value
        
        if constant: self.constants.add(var_name)
        return value
    
    def assign_variable(self, var_name: str, value: RuntimeValue) -> RuntimeValue:
        env: Environment = self.resolve(var_name)
        
        if var_name in env.constants:
            raise AttributeError(f"Cannot assign to variable '{var_name}' as it is const")
            
        env.variables[var_name] = value
        return value
    
    def lookup_variable(self, var_name: str) -> RuntimeValue:
        env: Environment = self.resolve(var_name)
        return env.variables[var_name]
    
    def resolve(self, var_name: str) -> "Environment":
        if var_name in self.variables:
            return self
        
        if self.parent is None:
            raise NameError(f"Cannot resolve variable '{var_name}' is not defined.")
        
        return self.resolve(var_name)
    
def setup_global_scope(env: Environment):
    # create default globals
    env.declare_variable("nil", NilVal())
    env.declare_variable("true", BooleanVal(True))
    env.declare_variable("false", BooleanVal(False))
    
    # create native methods
    env.declare_variable("log", NativeFunctionVal(FunctionCall()), true)