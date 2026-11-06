# PowerShell script to install skills to local agent harness directories:
#   - ~/.agents/skills (for Codex, Antigravity, and Agent Skills compatible tools)
#   - ~/.claude/skills (for Claude Code)

[CmdletBinding()]
param(
    [string[]]$Destinations = @(
        "$env:USERPROFILE\.agents\skills",
        "$env:USERPROFILE\.claude\skills"
    ),
    [switch]$IncludeInProgress
)

$RepoRoot = Split-Path -Parent $PSScriptRoot

$buckets = @("engineering", "productivity")
if ($IncludeInProgress) {
    $buckets += "in-progress"
}

$skills = @()
foreach ($bucket in $buckets) {
    $bucketPath = Join-Path $RepoRoot "skills\$bucket"
    if (Test-Path $bucketPath) {
        $dirs = Get-ChildItem -Path $bucketPath -Directory
        foreach ($d in $dirs) {
            $skillMd = Join-Path $d.FullName "SKILL.md"
            if (Test-Path $skillMd) {
                $skills += $d
            }
        }
    }
}

Write-Host "Found $($skills.Count) skills to install." -ForegroundColor Cyan

foreach ($dest in $Destinations) {
    if (-not (Test-Path $dest)) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
    }
    Write-Host "`nInstalling to: $dest" -ForegroundColor Green

    foreach ($skillDir in $skills) {
        $targetDir = Join-Path $dest $skillDir.Name
        if (Test-Path $targetDir) {
            Remove-Item -Path $targetDir -Recurse -Force
        }
        Copy-Item -Path $skillDir.FullName -Destination $targetDir -Recurse -Force
        Write-Host "  Installed: $($skillDir.Name)" -ForegroundColor Gray
    }
}

Write-Host "`nAll $($skills.Count) skills successfully installed!" -ForegroundColor Green
