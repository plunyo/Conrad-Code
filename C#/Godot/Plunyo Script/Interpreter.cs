using Godot;
using System;
using System.Collections.Generic;

public class Interpreter
{
    public Dictionary<string, object> Variables;
    private Console console;
    private ErrorBox errorBox; // Instance of ErrorBox to display errors
    private readonly Dictionary<string, Action<string[]>> builtInFunctions;

    public Interpreter(Console console, ErrorBox errorBox)
    {
        this.console = console;
        this.errorBox = errorBox; // Initialize the ErrorBox instance

        Variables = new Dictionary<string, object>();

        builtInFunctions = new Dictionary<string, Action<string[]>>()
        {
            { "write", WriteFunction }
        };
    }

    public void Execute(string line)
    {
        string[] tokens = line.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

        if (tokens.Length == 0)
            return;

        string command = tokens[0].ToLower();

        if (builtInFunctions.TryGetValue(command, out var function))
        {
            try
            {
                function(tokens[1..]);
                errorBox.ClearError(); // Clear any previous error when the function executes successfully
            }
            catch (Exception ex)
            {
                errorBox.RaiseError($"Execution failed: {ex.Message}", "EXEC_ERR");
            }
        }
        else
        {
            errorBox.RaiseError($"Unknown command: {command}", "CMD_ERR");
        }
    }

    private void WriteFunction(string[] args)
    {
        if (args.Length > 0)
        {
            string result = "";

            for (int i = 0; i < args.Length; i++)
            {
                string arg = args[i].Trim();

                if (arg == "+")
                {
                    continue;
                }

                if (arg.StartsWith("|") && arg.EndsWith("|") && arg.Length > 2)
                {
                    result += arg.Substring(1, arg.Length - 2);
                }
                else if (arg == "|" || arg == "||")
                {
                    result += " ";
                }
                else if (Variables.ContainsKey(arg))
                {
                    result += Variables[arg]?.ToString();
                }
                else
                {
                    errorBox.RaiseError($"Undefined variable: {arg}", "VAR_ERR");
                    return; // Stop processing if an error occurs
                }
            }

            console.Write(result + "\n");
            errorBox.ClearError(); // Clear any previous error after successful writing
        }
        else
        {
            errorBox.RaiseError("Write function requires at least one argument.", "ARG_ERR");
        }
    }
}