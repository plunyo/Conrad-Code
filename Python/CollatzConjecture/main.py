import time


def main():
    while True:
        try:
            start_num = int(input("Choose your starting number: ").strip())
        except ValueError:
            print("Please enter a valid integer.")
            continue

        if start_num <= 0:
            print("Please enter a positive integer.")
            continue

        while start_num != 1:
            print(start_num)
            start_num = start_num // 2 if start_num % 2 == 0 else start_num * 3 + 1

        print("Reached 1!")

        again = input("Would you like to exit [Y]es/[N]o: ")

        if again.lower() != "n":
            break


if __name__ == "__main__":
    main()
