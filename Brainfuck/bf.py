memory = [0] * 30000
pointer = 0

def brainfuck(input: str):
    print()

    for i in range(len(input)):
        match input[i]:
            case "+":
                memory[pointer] += 1
            case "-":
                memory[pointer] -= 1
            case ">":
                pointer += 1
            case "<":
                memory[pointer] -= 1
            case "[":
                count = 1
                while count > 0:
                    i += 1
                    if input[i] == "[":
                        count += 1
                    elif input[i] == "]":
                        count -= 1
            case "]":
                if memory[pointer] != 0:
                    count = 1
                    while count > 0:
                        i -= 1
                        if input[i] == "]":
                            count += 1
                        elif input[i] == "[":
                            count -= 1
            case ",":
                ord(input()[0])
            case ".":
                memory[pointer] -= 1
            case _:
                continue
