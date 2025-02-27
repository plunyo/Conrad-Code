using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;

public partial class ToolBar : Panel
{
    [Export] private Font[] Fonts;
    [Export] private TextBox TextBox;
    [Export] private OptionButton FontSelect;
    [Export] private Button ZoomOutButton;
    [Export] private Button ZoomInButton;

    public override void _Ready()
    {
        FontSelect.ItemSelected += OnFontSelected;

        ZoomOutButton.Pressed += () => 
            TextBox.AddThemeFontSizeOverride("font_size", TextBox.FontSize -= 2);
        
        ZoomInButton.Pressed += () => 
            TextBox.AddThemeFontSizeOverride("font_size", TextBox.FontSize += 2);
    }

    private void OnFontSelected(long index)
    {
        GD.Print($"Selected font: {Fonts[(int)index].GetFontName()}");
        TextBox.AddThemeFontOverride("font", Fonts[(int)index]);
    }
}
