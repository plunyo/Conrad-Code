using System;

namespace GoofyCalculator
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Welcome to the Goofy Calculator! Prepare for some wacky math!\n");

            while (true)
            {
                Console.WriteLine("Enter the first number:");
                if (!double.TryParse(Console.ReadLine(), out double num1))
                {
                    Console.WriteLine("Oops! That's not a number. Try again, silly goose!\n");
                    continue;
                }

                Console.WriteLine("Choose an operation (+, -, *, /, or surprise):");
                string operation = Console.ReadLine();

                Console.WriteLine("Enter the second number:");
                if (!double.TryParse(Console.ReadLine(), out double num2))
                {
                    Console.WriteLine("Are you pranking me? That's not a number!\n");
                    continue;
                }

                try
                {
                    switch (operation)
                    {
                        case "+":
                            Console.WriteLine($"Result: {num1} + {num2} = {num1 + num2}\n");
                            break;
                        case "-":
                            Console.WriteLine($"Result: {num1} - {num2} = {num1 - num2}\n");
                            break;
                        case "*":
                            Console.WriteLine($"Result: {num1} * {num2} = {num1 * num2}\n");
                            break;
                        case "/":
                            if (num2 == 0)
                            {
                                Console.WriteLine("Dividing by zero? Really? Are you trying to break the universe?\n");
                            }
                            else
                            {
                                Console.WriteLine($"Result: {num1} / {num2} = {num1 / num2}\n");
                            }
                            break;
                        case "surprise":
                            Console.WriteLine($"Surprise! Your numbers multiplied, added, and then divided by 3 are: {(num1 * num2 + num1 + num2) / 3}\n");
                            break;
                        default:
                            Console.WriteLine("That operation is too goofy even for me! Try again with a valid one.\n");
                            break;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Something went terribly goofy: {ex.Message}\n");
                }

                Console.WriteLine("Do you want to calculate again? (yes/no):");
                string response = Console.ReadLine().ToLower();
                if (response != "yes")
                {
                    Console.WriteLine("Thanks for using the Goofy Calculator! Stay silly!\n");
                    break;
                }
            }
        }
    }
}
