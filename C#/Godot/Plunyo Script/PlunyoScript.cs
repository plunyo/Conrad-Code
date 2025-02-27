using Godot;
using System.Collections.Generic;

public partial class PlunyoScript : Control
{
    [Export] ErrorBox ErrorBox;
    [Export] CodeEdit CodeBox;
    [Export] Button RunButton;
    [Export] Console Console;

    private Interpreter interpreter;
    private Dictionary<string, object> variables;
    private string[] lines;

    public override void _Ready()
    {
        base._Ready();
        interpreter = new Interpreter(Console, ErrorBox);

        CodeBox.TextChanged += onCodeChanged;
        RunButton.Pressed += onRunPressed;
    }

    private void onCodeChanged()
    {
        lines = CodeBox.Text.Split('\n');
        interpreter.Variables = variables = Parser.ParseVariables(lines);
    }

    private void onRunPressed()
    {
        Console.Clear();

        foreach (string line in lines)
        {
            string trimmedLine = line.Trim();
            
            if (string.IsNullOrEmpty(trimmedLine) || IsVariableDeclaration(trimmedLine)) continue;

            interpreter.Execute(trimmedLine);
        }
    }

    private bool IsVariableDeclaration(string line)
    {
        string[] tokens = line.Split(new[] { ' ' }, System.StringSplitOptions.RemoveEmptyEntries);
        return tokens.Length >= 4 && tokens[0] == "new" && tokens[2] == "=";
    }
}
