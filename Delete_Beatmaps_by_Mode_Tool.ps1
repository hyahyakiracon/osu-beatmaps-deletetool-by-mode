# Get the Songs folder path
$songsFolder = Join-Path -Path $PSScriptRoot -ChildPath "Songs"

# Check if the Songs folder exists
if (-not (Test-Path -Path $songsFolder -PathType Container)) {
    Write-Host "Songs folder does not exist. Please make sure the script is placed next to the Songs folder."
    exit
}

# Ask the user for the mode to delete (0 for standard, 1 for taiko, 2 for catch, 3 for mania)
$modeToDelete = Read-Host "Enter the mode to delete (0 for standard, 1 for taiko, 2 for catch, 3 for mania):"

# Validate the user input for mode
if ($modeToDelete -notin "0", "1", "2", "3") {
    Write-Host "Invalid input. Please enter 0, 1, 2, or 3."
    exit
}

# Record deleted .osu files and folders
$deletedFiles = @()
$deletedFolders = @()

# Iterate through all folders in the Songs folder
Get-ChildItem -Path $songsFolder -Directory | ForEach-Object {
    $currentFolder = $_.FullName
    Write-Host "Processing folder: '$currentFolder'"
    
    # Get all .osu files in the current folder
    $osuFiles = Get-ChildItem -LiteralPath $currentFolder -Filter "*.osu" -File
    
    # Iterate through each .osu file and delete files with the specified mode
    foreach ($file in $osuFiles) {
        $content = Get-Content -LiteralPath $file.FullName -TotalCount 20
        $patternFound = $false
        foreach ($line in $content) {
            if ($line -match "Mode:\s*${modeToDelete}") {  # Updated this line
                $patternFound = $true
                break
            }
        }
        if ($patternFound) {
            Write-Host "Found .osu file with mode ${modeToDelete}: '$($file.Name)'."  # Updated this line
            Write-Host "Deleting file: '$($file.FullName)'."
            Remove-Item -LiteralPath $file.FullName -Force
            $deletedFiles += $file.FullName
        }
    }
    
    # Check if the current folder is empty after deletion, if so, delete the current folder
    $isEmpty = @(Get-ChildItem -LiteralPath $currentFolder -File -Filter "*.osu").Count -eq 0
    if ($isEmpty) {
        Write-Host "Folder '$currentFolder' does not contain any .osu files and will be deleted."
        Remove-Item -LiteralPath $currentFolder -Force -Recurse
        $deletedFolders += $currentFolder
    }
}

# Display deleted files and folders
if ($deletedFiles.Count -gt 0) {
    Write-Host "Deleted .osu files with Mode:${modeToDelete}:"  # Updated this line
    $deletedFiles | ForEach-Object {
        Write-Host "  $_"
    }
} else {
    Write-Host "No .osu files with Mode:${modeToDelete} found."  # Updated this line
}

if ($deletedFolders.Count -gt 0) {
    Write-Host "Deleted folders without any .osu files:"
    $deletedFolders | ForEach-Object {
        Write-Host "  $_"
    }
} else {
    Write-Host "No folders without any .osu files deleted."
}

Write-Host "Operation completed."
Read-Host -Prompt "Press any key to continue..."
