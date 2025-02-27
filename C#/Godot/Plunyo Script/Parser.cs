using System;
using System.Collections.Generic;

public static class Parser
{
    public static Dictionary<string, object> ParseVariables(string[] lines)
    {
        var variables = new Dictionary<string, object>();

        foreach (string line in lines)
        {
            string[] tokens = line.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            if (tokens.Length >= 4 && tokens[0].Trim() == "new" && tokens[2].Trim() == "=")
            {
                string name = tokens[1].Trim();
                var value = ParseValue(tokens[3].Trim());

                if (variables.ContainsKey(name))
                {
                    variables[name] = value;
                }
                else
                {
                    variables.Add(name, value);
                }
            }
        }

        return variables;
    }

    public static object ParseValue(string value)
    {
        if (int.TryParse(value, out var intValue))
        {
            return intValue;
        }
        if (float.TryParse(value, out var floatValue))
        {
            return floatValue;
        }
        if (bool.TryParse(value, out var boolValue))
        {
            return boolValue;
        }

        return value;
    }
}
