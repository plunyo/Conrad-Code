add = lambda x, y, z: x + y + z

numbers = [1, 3, 5, 7, 9, 11, 13, 15]

target_sum = 31

solutions_found = False

for x in range(len(numbers)):
    for y in range(x + 1, len(numbers)):
        for z in range(y + 1, len(numbers)):
            if add(numbers[x], numbers[y], numbers[z]) == target_sum:
                print(f"Solution: {numbers[x]} + {numbers[y]} + {numbers[z]} = {target_sum}")
                solutions_found = True

if not solutions_found:
    print("No can do, buckaroo")
