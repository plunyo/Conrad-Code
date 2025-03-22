@echo off
set "current_path=%~dp0"
echo Current script directory: %current_path%
set "parent_path=%current_path:~0,-1%"
"C:\Program Files\LOVE\love.exe" "%parent_path%"