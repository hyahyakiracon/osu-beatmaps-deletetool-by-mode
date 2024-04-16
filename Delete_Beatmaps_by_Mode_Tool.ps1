# ��ȡSongs�ļ���·��
$songsFolder = Join-Path -Path $PSScriptRoot -ChildPath "Songs"

# ���Songs�ļ����Ƿ����
if (-not (Test-Path -Path $songsFolder -PathType Container)) {
    Write-Host "Songs�ļ��в����ڣ���ȷ���ű�����Songs�ļ����Աߡ�"
    exit
}

# ѯ���û���Ҫɾ����ģʽ
$modeToDelete = Read-Host "������Ҫɾ����ģʽ��0��1��2��3����"

# ��֤�û������ģʽ�Ƿ���Ч
if ($modeToDelete -notin "0", "1", "2", "3") {
    Write-Host "��Ч�����롣������0��1��2��3��"
    exit
}

# ��¼��ɾ����.osu�ļ����ļ���
$deletedFiles = @()
$deletedFolders = @()

# ����Songs�ļ����ڵ������ļ���
Get-ChildItem -Path $songsFolder -Directory | ForEach-Object {
    $currentFolder = $_.FullName
    Write-Host "���ڴ����ļ��У�'$currentFolder'"
    
    # ��ȡ��ǰ�ļ����ڵ�����.osu�ļ�
    $osuFiles = Get-ChildItem -LiteralPath $currentFolder -Filter "*.osu" -File
    
    # ����ÿ��.osu�ļ���ɾ��ָ��ģʽ���ļ�
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
            Write-Host "����������ģʽ $modeToDelete ��.osu�ļ���'$($file.Name)'�����е�ModeֵΪ $modeToDelete��"
            Write-Host "����ɾ���ļ���'$($file.FullName)'"
            Remove-Item -LiteralPath $file.FullName -Force
            $deletedFiles += $file.FullName
        }
    }
    
    # ���ɾ����ǰ�ļ����Ƿ�û��.osu�ļ����������ɾ����ǰ�ļ���
    $isEmpty = @(Get-ChildItem -LiteralPath $currentFolder -File -Filter "*.osu").Count -eq 0
    if ($isEmpty) {
        Write-Host "�ļ��� '$currentFolder' �������κ�.osu�ļ�������ɾ����"
        Remove-Item -LiteralPath $currentFolder -Force -Recurse
        $deletedFolders += $currentFolder
    }
}

# ��ʾ��ɾ�����ļ����ļ���
if ($deletedFiles.Count -gt 0) {
    Write-Host "��ɾ�����´��� Mode:$modeToDelete �� .osu �ļ���"
    $deletedFiles | ForEach-Object {
        Write-Host "  $_"
    }
} else {
    Write-Host "δ�ҵ����� Mode:$modeToDelete �� .osu �ļ���"
}

if ($deletedFolders.Count -gt 0) {
    Write-Host "��ɾ�����²������κ�.osu�ļ����ļ��У�"
    $deletedFolders | ForEach-Object {
        Write-Host "  $_"
    }
} else {
    Write-Host "δɾ���κβ������κ�.osu�ļ����ļ��С�"
}

Write-Host "������ɡ�"
Read-Host -Prompt "�����������..."
