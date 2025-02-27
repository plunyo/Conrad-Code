using Godot;
using System;

public partial class Console : RichTextLabel
{
	public void Write(string text)
	{
		AppendText("	" + text);
	}
}
