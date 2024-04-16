# 获取Songs文件夹路径
$songsFolder = Join-Path -Path $PSScriptRoot -ChildPath "Songs"

# 检查Songs文件夹是否存在
if (-not (Test-Path -Path $songsFolder -PathType Container)) {
    Write-Host "Songs文件夹不存在，请确保脚本放在Songs文件夹旁边。"
    exit
}

# 询问用户需要删除的模式
$modeToDelete = Read-Host "请输入要删除的模式（0、1、2或3）(0 for std,1 for taiko,2 for catch,3 for mania)："

# 验证用户输入的模式是否有效
if ($modeToDelete -notin "0", "1", "2", "3") {
    Write-Host "无效的输入。请输入0、1、2或3。"
    exit
}

# 记录已删除的.osu文件和文件夹
$deletedFiles = @()
$deletedFolders = @()

# 遍历Songs文件夹内的所有文件夹
Get-ChildItem -Path $songsFolder -Directory | ForEach-Object {
    $currentFolder = $_.FullName
    Write-Host "正在处理文件夹：'$currentFolder'"
    
    # 获取当前文件夹内的所有.osu文件
    $osuFiles = Get-ChildItem -LiteralPath $currentFolder -Filter "*.osu" -File
    
    # 遍历每个.osu文件，删除指定模式的文件
    foreach ($file in $osuFiles) {
        $content = Get-Content -LiteralPath $file.FullName -TotalCount 20
        $patternFound = $false
        foreach ($line in $content) {
            if ($line -match "Mode:\s*$modeToDelete") {
                $patternFound = $true
                break
            }
        }
        if ($patternFound) {
            Write-Host "检索到符合模式 $modeToDelete 的.osu文件：'$($file.Name)'，其中的Mode值为 $modeToDelete。"
            Write-Host "正在删除文件：'$($file.FullName)'"
            Remove-Item -LiteralPath $file.FullName -Force
            $deletedFiles += $file.FullName
        }
    }
    
    # 检查删除后当前文件夹是否没有.osu文件，如果是则删除当前文件夹
    $isEmpty = @(Get-ChildItem -LiteralPath $currentFolder -File -Filter "*.osu").Count -eq 0
    if ($isEmpty) {
        Write-Host "文件夹 '$currentFolder' 不包含任何.osu文件，将被删除。"
        Remove-Item -LiteralPath $currentFolder -Force -Recurse
        $deletedFolders += $currentFolder
    }
}

# 显示已删除的文件和文件夹
if ($deletedFiles.Count -gt 0) {
    Write-Host "已删除以下带有 Mode:$modeToDelete 的 .osu 文件："
    $deletedFiles | ForEach-Object {
        Write-Host "  $_"
    }
} else {
    Write-Host "未找到带有 Mode:$modeToDelete 的 .osu 文件。"
}

if ($deletedFolders.Count -gt 0) {
    Write-Host "已删除以下不包含任何.osu文件的文件夹："
    $deletedFolders | ForEach-Object {
        Write-Host "  $_"
    }
} else {
    Write-Host "未删除任何不包含任何.osu文件的文件夹。"
}

Write-Host "操作完成。"
Read-Host -Prompt "按任意键继续..."
