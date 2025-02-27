from enum import Enum
from typing import Dict, List
from runtime.environment import Environment

class ValueType(Enum):
    Nil = "nil"
    Number = "number"
    Bool = "boolean"
    Object = "Object"
    NativeFunction = "NativeFunction"

class RuntimeValue:
    def __init__(self, type: ValueType):
        self.type = type

    def __repr__(self):
        return f"{self.__class__.__name__}( type = { self.type.value} )"

class BooleanVal(RuntimeValue):
    def __init__(self, value: bool = True):
        super().__init__(ValueType.Bool)
        self.value = value
    
    def __repr__(self):
        return f"BooleanVal( value = {self.value} )"

class NilVal(RuntimeValue):
    def __init__(self):
        super().__init__(ValueType.Nil)
        self.value = "nil"

    def __repr__(self):
        return f"Nil()"

class NumberVal(RuntimeValue):
    def __init__(self, value: float):
        super().__init__(ValueType.Number)
        self.value = value

    def __repr__(self):
        return f"NumberVal( value = {self.value} )"

class ObjectVal(RuntimeValue):
    def __init__(self, properties: Dict[str, RuntimeValue]):
        super().__init__(ValueType.Object)
        self.properties = properties

    def __repr__(self):
        return f"ObjectVal( properties = {self.properties} )"
    
class FunctionCall():
    def __init__(self, args: List[RuntimeValue], env: Environment) -> RuntimeValue:
        self.args = args
        
class NativeFunctionVal(RuntimeValue):
    def __init__(self, call: FunctionCall):
        super().__init__(ValueType.NativeFunction)
        self.call = call
        