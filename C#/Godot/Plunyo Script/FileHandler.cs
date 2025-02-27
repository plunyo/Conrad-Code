using Godot;
using System;

public partial class FileHandler : Control
{
    [Export] private FileDialog FileSelector;
    [Export] private FileDialog FileSaver;

    [Export] private Button ExportButton;
    [Export] private Button ImportButton;

    [Export] private CodeEdit CodeBox;

    public override void _Ready()
    {
        FileSelector.FileSelected += FileSelector_OnFileSelected;
        FileSaver.FileSelected += FileSaver_OnFileSelected;

        ExportButton.Pressed += OnExportPressed;
        ImportButton.Pressed += OnImportPressed;
    }

    private void FileSelector_OnFileSelected(string filePath)
    {
        if (!filePath.EndsWith(".ps")) return;

        FileAccess file = FileAccess.Open(filePath, FileAccess.ModeFlags.Read);
        string content = file.GetAsText();
        CodeBox.Text = content;
    }

    private void FileSaver_OnFileSelected(string filePath)
    {
        if (!filePath.EndsWith(".ps")) return;

        FileAccess file = FileAccess.Open(filePath, FileAccess.ModeFlags.Write);
        file.StoreString(CodeBox.Text);
        GD.Print("File saved: " + filePath);
    }

    private void OnExportPressed()
    {
        GD.Print("Export button pressed");
        FileSaver.PopupCentered();
    }

    private void OnImportPressed()
    {
        GD.Print("Import button pressed");
        FileSelector.PopupCentered();
    }
}
