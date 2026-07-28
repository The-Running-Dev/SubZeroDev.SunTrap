<#[
.SYNOPSIS
Checks generated documentation, local Markdown links, and terminology.
#>
[CmdletBinding()]
param()

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$rules = Import-PowerShellDataFile -LiteralPath (Join-Path $repositoryRoot '.config/DocumentationRules.psd1')
$problems = [System.Collections.Generic.List[string]]::new()

function Get-RelativePath {
    param([string]$Path)
    [IO.Path]::GetRelativePath($repositoryRoot, $Path).Replace('\', '/')
}

function Test-IsExcluded {
    param([string]$Path)
    $segments = (Get-RelativePath $Path).Split('/')
    return @($rules.ExcludedSegments | Where-Object { $segments -contains $_ }).Count -gt 0
}

function Get-AnchorSet {
    param([string]$Path)
    $anchors = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    $counts = @{}
    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($line -notmatch '^\s{0,3}#{1,6}\s+(.+?)\s*$') { continue }
        $heading = $Matches[1]
        if ($heading -match '\{#([^}]+)\}\s*$') { $null = $anchors.Add($Matches[1]); continue }
        $slug = ($heading -replace '!?(\[[^\]]*\]\([^)]*\))', '$1' -replace '[`*_~]', '').Trim().ToLowerInvariant()
        $slug = [regex]::Replace($slug, '[^a-z0-9 \-]', '')
        $slug = [regex]::Replace($slug, '\s', '-')
        $slug = $slug.Trim('-')
        if ([string]::IsNullOrWhiteSpace($slug)) { continue }
        if ($counts.ContainsKey($slug)) { $counts[$slug]++; $null = $anchors.Add("$slug-$($counts[$slug])") }
        else { $counts[$slug] = 0; $null = $anchors.Add($slug) }
    }
    return $anchors
}

foreach ($generated in $rules.GeneratedFiles) {
    $generator = Join-Path $repositoryRoot $generated.Generator
    $source = Join-Path $repositoryRoot $generated.Source
    $target = Join-Path $repositoryRoot $generated.Path
    $arguments = @{$generated.SourceParameter = $source}
    foreach ($entry in $generated.Arguments.GetEnumerator()) { $arguments[$entry.Key] = $entry.Value }
    $expected = (& $generator @arguments) -join "`n"
    $actual = Get-Content -LiteralPath $target -Raw -ErrorAction SilentlyContinue
    if (($expected -replace "`r`n?", "`n").TrimEnd("`n") -cne ($actual -replace "`r`n?", "`n").TrimEnd("`n")) {
        $problems.Add("$($generated.Path): generated file differs from $($generated.Source)")
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $repositoryRoot -Filter '*.md' -File -Recurse |
    Where-Object { -not (Test-IsExcluded $_.FullName) }

foreach ($file in $markdownFiles) {
    $lines = Get-Content -LiteralPath $file.FullName
    for ($lineNumber = 0; $lineNumber -lt $lines.Count; $lineNumber++) {
        $line = $lines[$lineNumber]
        foreach ($match in [regex]::Matches($line, '(?<!\!)\[[^\]]+\]\(([^ )]+)(?:\s+"[^"]*")?\)')) {
            $target = $match.Groups[1].Value.Trim('<', '>')
            if ($target -match '^(https?|mailto|ftp):' -or $target.StartsWith('/')) { continue }
            $parts = $target.Split('#', 2)
            $relativeTarget = $parts[0]
            $fragment = if ($parts.Count -eq 2) { $parts[1] } else { '' }
            $targetPath = if ($relativeTarget) { Join-Path $file.DirectoryName ([uri]::UnescapeDataString($relativeTarget)) } else { $file.FullName }
            if (-not (Test-Path -LiteralPath $targetPath)) {
                $problems.Add("$(Get-RelativePath $file.FullName):$($lineNumber + 1): missing link target '$relativeTarget'")
                continue
            }
            if ($fragment -and $targetPath.EndsWith('.md') -and -not (Get-AnchorSet $targetPath).Contains($fragment)) {
                $problems.Add("$(Get-RelativePath $file.FullName):$($lineNumber + 1): missing anchor '#$fragment'")
            }
        }
        foreach ($term in $rules.Terminology) {
            foreach ($variant in $term.Variants) {
                if ($line -cmatch "(?<![\w-])$([regex]::Escape($variant))(?![\w-])") {
                    $problems.Add("$(Get-RelativePath $file.FullName):$($lineNumber + 1): use '$($term.Required)' instead of '$variant'")
                }
            }
        }
    }
}

if ($problems.Count) {
    $problems | ForEach-Object { Write-Error $_ }
    throw "Documentation checks failed with $($problems.Count) issue(s)."
}

Write-Host "Documentation checks passed across $($markdownFiles.Count) Markdown file(s)." -ForegroundColor Green
