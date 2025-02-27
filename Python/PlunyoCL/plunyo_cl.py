from sys import argv
from frontend.parser import Parser
from runtime.values import *
from runtime.interpreter import evaluate
from runtime.environment import Environment

def main():
    parser = Parser()
    env = Environment()
    
    # check if a file arg was provided and if it ends with ".pcl"
    if len(argv) > 1 and argv[1].endswith(".pcl"):
        with open(argv[1], 'r') as file:
            source_code = file.read()
            # evaluate the source code from the file
            result = evaluate(parser.generate_ast(source_code), env)
            print(result)
    else:
        # start an interactive prompt
        while True:
            source_code = input("PlunyoCL > ")
            if source_code == "exit":
                return  # exit the loop and terminate
            # evaluate the inputted source code
            result = evaluate(parser.generate_ast(source_code), env)
            print(result)
            
if __name__ == "__main__":
    main()
