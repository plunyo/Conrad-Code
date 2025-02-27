using Godot;
using System;
using System.Xml;

public partial class TextBox : CodeEdit
{
    public int FontSize;

    [Export] private Button SaveButton;
    [Export] private Button SOFCButton;
    [Export] private Button OpenFileButton;
    [Export] private Button OpenFolderButton;
    
    [Export] private FileDialog SelectFileDialog;
    [Export] private FileDialog SaveFileDialog;
    [Export] private FileDialog OpenFolderDialog;

    [Export] private ProjectTree ProjectTree;
    [Export] private CheckButton CodeModeButton;

    private string currentFilePath = string.Empty;

    public override void _Ready()
    {
        FontSize = GetThemeFontSize("font_size");

        SaveButton.Pressed += SaveFile;
        OpenFileButton.Pressed += () => SelectFileDialog.Popup();

        SelectFileDialog.FileSelected += (string path) => 
        {
            currentFilePath = path; 
            LoadFile(currentFilePath);
        };

        SaveFileDialog.FileSelected += (string path) => 
        {
            currentFilePath = path; 
            SaveFile();
        };

        OpenFolderButton.Pressed += () => OpenFolderDialog.Popup();

        OpenFolderDialog.DirSelected += (string path) => 
            ProjectTree.BuildTree(ProjectTree.GetRoot(), path);
        

        CodeModeButton.Pressed += OnCodeModeButtonPressed;
    }

    public void LoadFile(string path)
    {   
        if (FileAccess.FileExists(currentFilePath) && SOFCButton.ButtonPressed)
        {
            SaveFile();
        }

        if (!string.IsNullOrEmpty(path) && !DirAccess.DirExistsAbsolute(path))
        {
            using var file = FileAccess.Open(path, FileAccess.ModeFlags.Read);
            Text = file.GetAsText();
            currentFilePath = path;
            GD.Print("File loaded successfully: " + path);
        }
        else
        {
            GD.Print("Invalid file, probably a directory.");
        }
    }

    public void SaveFile()
    {
        if (string.IsNullOrEmpty(currentFilePath))
        {
            SaveFileDialog.Popup();
        }
        else
        {
            using var file = FileAccess.Open(currentFilePath, FileAccess.ModeFlags.Write);
            file.StoreString(Text);
            GD.Print("File saved successfully: " + currentFilePath);
        }
    }

    private void CreateNewFile(string path)
    {
        if (!string.IsNullOrEmpty(path))
        {
            using var file = FileAccess.Open(path, FileAccess.ModeFlags.Write);
            file.StoreString(Text);
            GD.Print("New file created successfully: " + path);
        }
        else
        {
            GD.PrintErr("Path is empty. Cannot create a new file.");
        }
    }

    private void OnCodeModeButtonPressed()
    {
        GuttersDrawLineNumbers = CodeModeButton.ButtonPressed;
        DrawTabs = CodeModeButton.ButtonPressed;
        AutoBraceCompletionEnabled = CodeModeButton.ButtonPressed;
    }
}
