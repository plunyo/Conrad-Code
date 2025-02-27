using Godot;

public partial class ProjectTree : Tree
{
    private enum ButtonType
    {
        CreateFile,
        CreateFolder,
        Remove
    }

    // Current directory path
    public string currentDirPath = string.Empty;

    [Export] private TextBox TextBox;

    [Export] private FileDialog SelectFileDialog;
    [Export] private FileDialog SaveFileDialog;

    [Export] private AcceptDialog NameFileDialog;
    [Export] private AcceptDialog NameFolderDialog;
    [Export] private AcceptDialog DuplicateDialog;

    [Export] private ConfirmationDialog RemoveDialog;

    private Texture2D createFileIcon;
    private Texture2D createFolderIcon;
    private Texture2D removeIcon;

    private Timer refreshTimer;

    public override void _Ready()
    {
        OS.Execute("python", new string[] {"res://test.py"}, null, false, true);

        TreeItem root = CreateItem();
        HideRoot = true;

        // Load icons
        createFileIcon = GD.Load<Texture2D>("res://Icons/FileCreate.svg");
        createFolderIcon = GD.Load<Texture2D>("res://Icons/FolderCreate.svg");
        removeIcon = GD.Load<Texture2D>("res://Icons/Remove.svg");

        // Connect signals
        SelectFileDialog.FileSelected += (string path) => BuildTree(GetRoot(), path);
        SaveFileDialog.FileSelected += (string path) => BuildTree(GetRoot(), path);

        RemoveDialog.Confirmed += () => RemoveItem(GetSelected());

        ItemActivated += () => TextBox.LoadFile(GetSelected().GetMetadata(0).ToString());

        // Handle button clicks in the tree
        // i gotta do this bcs godot hate me and just want me to suffer
        #pragma warning disable CS1998
        ButtonClicked += async (TreeItem item, long column, long id, long mouseButtonIndex) =>
        {
            if (mouseButtonIndex == (long)MouseButton.Left)
            {
                switch ((ButtonType)id)
                {
                    case ButtonType.CreateFile:
                        CreateFile(item);
                        break;
                    case ButtonType.CreateFolder:
                        CreateFolder(item);
                        break;
                    case ButtonType.Remove:
                        item.Select(0);
                        RemoveDialog.Popup();
                        break;
                }
            }
        };
    }

    private async void CreateFile(TreeItem item)
    {
        NameFileDialog.Popup();
        await ToSignal(NameFileDialog, "confirmed");

        LineEdit nameInput = NameFileDialog.GetNode<LineEdit>("NameInput");
        string fileName = string.IsNullOrWhiteSpace(nameInput.Text) ? nameInput.PlaceholderText : nameInput.Text;

        string fullPath = $"{currentDirPath}/{fileName}";

        if (FileAccess.FileExists(fullPath))
        {
            GD.Print($"File already exists: {fullPath}");
            DuplicateDialog.Popup();
            return;
        }

        var fileAccess = FileAccess.Open(fullPath, FileAccess.ModeFlags.Write);
        if (fileAccess != null)
        {
            fileAccess.Close();
            GD.Print($"File created: {fullPath}");

            TreeItem fileItem = CreateItem(item);
            fileItem.SetText(0, fileName);
            fileItem.SetMetadata(0, fullPath);

            fileItem.AddButton(0, removeIcon, (int)ButtonType.Remove);
        }
        else
        {
            GD.Print($"Failed to create file: {fullPath}");
        }
    }

    private async void CreateFolder(TreeItem item)
    {
        NameFolderDialog.Popup();
        await ToSignal(NameFolderDialog, "confirmed");

        LineEdit nameInput = NameFolderDialog.GetNode<LineEdit>("NameInput");
        string folderName = string.IsNullOrWhiteSpace(nameInput.Text) ? nameInput.PlaceholderText : nameInput.Text;

        string parentDirPath = currentDirPath;

        string fullPath = $"{parentDirPath}/{folderName}";

        if (DirAccess.DirExistsAbsolute(fullPath))
        {
            GD.Print($"Folder already exists: {fullPath}");
            DuplicateDialog.Popup();
            return;
        }

        if (DirAccess.MakeDirAbsolute(fullPath) == Error.Ok)
        {
            GD.Print($"Folder created: {fullPath}");

            TreeItem folderItem = CreateItem(item);
            folderItem.SetText(0, folderName);
            folderItem.SetMetadata(0, fullPath);

            folderItem.AddButton(0, createFileIcon, (int)ButtonType.CreateFile);
            folderItem.AddButton(0, createFolderIcon, (int)ButtonType.CreateFolder);
            folderItem.AddButton(0, removeIcon, (int)ButtonType.Remove);
        }
        else
        {
            GD.Print($"Failed to create folder: {fullPath}");
        }
    }


    public void BuildTree(TreeItem parent, string path)
    {
        ClearChildren(parent);

        if (FileAccess.FileExists(path))
        {
            path = path.GetBaseDir();
        }
        else if (!DirAccess.DirExistsAbsolute(path))
        {
            GD.PrintErr($"Path does not exist or is invalid: {path}");
            return;
        }

        DirAccess dir = DirAccess.Open(path);
        if (dir == null)
        {
            GD.Print($"Unable to open directory, probably a file: {path}");
            return;
        }

        currentDirPath = path;

        dir.ListDirBegin();
        string itemName;
        
        while (true)
        {
            itemName = dir.GetNext();
            if (itemName == "") break;

            string fullPath = $"{path}/{itemName}";

            if (dir.CurrentIsDir())
            {
                CreateFolderItem(parent, itemName, fullPath);
            }
            else
            {
                CreateFileItem(parent, itemName, fullPath);
            }
        }

        dir.ListDirEnd();
    }

    private void CreateFolderItem(TreeItem parent, string itemName, string fullPath)
    {
        TreeItem folderItem = CreateItem(parent);

        folderItem.SetText(0, itemName);
        folderItem.SetMetadata(0, fullPath);
        folderItem.SetCollapsedRecursive(true);

        folderItem.AddButton(0, createFileIcon, (int)ButtonType.CreateFile);
        folderItem.AddButton(0, createFolderIcon, (int)ButtonType.CreateFolder);
        folderItem.AddButton(0, removeIcon, (int)ButtonType.Remove);

        BuildTree(folderItem, fullPath);
    }

    private void CreateFileItem(TreeItem parent, string itemName, string fullPath)
    {
        TreeItem fileItem = CreateItem(parent);
        fileItem.SetText(0, itemName);
        fileItem.SetMetadata(0, fullPath);

        fileItem.AddButton(0, removeIcon, (int)ButtonType.Remove);
    }

    protected async void RemoveItem(TreeItem item)
    {
        string path = item.GetMetadata(0).ToString();

        GD.Print($"Removing item: {path}");
        OS.MoveToTrash(path);
        ClearChildren(item);
        item.Free();
    }

    protected void ClearChildren(TreeItem parent)
    {
        if (parent == null) return;

        TreeItem child = parent.GetFirstChild();
        while (child != null)
        {
            TreeItem nextChild = child.GetNext();
            child.Free();
            child = nextChild;
        }
    }
}
