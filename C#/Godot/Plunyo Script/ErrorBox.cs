using Godot;
using System;
using System.Collections.Generic;

public partial class ErrorBox : RichTextLabel
{
    public void RaiseError(string message, string errorCode)
    {
        Text = $"Error [{errorCode}]: {message}";
        GD.PrintErr($"Error [{errorCode}]: {message}");
    }

    public void ClearError()
    {
        Text = "";
    }
}
