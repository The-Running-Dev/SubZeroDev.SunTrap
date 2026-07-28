<#[
.SYNOPSIS
Builds the documentation homepage from the repository README.

.DESCRIPTION
The README is rendered on GitHub and as the documentation site's root page.
This generator keeps one source of truth and rewrites the published site origin
to a site-relative path for the documentation version.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$ReadmePath = 'README.md',

    [Parameter()]
    [string]$Title = 'Home',

    [Parameter()]
    [string]$Description = '',

    [Parameter()]
    [string]$SiteUrl = '',

    [Parameter()]
    [string]$RouteBasePath = '/',

    [Parameter()]
    [string]$OutputPath
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

function ConvertTo-YamlScalar {
    param([Parameter(Mandatory)][string]$Value)
    return "'$((($Value -replace '\r\n?|\n', ' ').Trim()).Replace("'", "''"))'"
}

if (-not (Test-Path -LiteralPath $ReadmePath -PathType Leaf)) {
    throw "README not found: $ReadmePath"
}

$frontMatter = @('---', "title: $(ConvertTo-YamlScalar $Title)")
if (-not [string]::IsNullOrWhiteSpace($Description)) {
    $frontMatter += "description: $(ConvertTo-YamlScalar $Description)"
}
$isSiteRoot = $RouteBasePath.Trim('/') -ne ''
if (-not $isSiteRoot) {
    $frontMatter += 'sidebar_position: 1'
}
$frontMatter += '---', ''

$body = (Get-Content -LiteralPath $ReadmePath -Raw) -replace "`r`n?", "`n"
if (-not [string]::IsNullOrWhiteSpace($SiteUrl)) {
    $body = $body.Replace($SiteUrl, '/')
}

if ($isSiteRoot) {
    $docsPath = '/' + $RouteBasePath.Trim('/') + '/'
    $body = $body.TrimEnd() + "`n`n[View the documentation]($docsPath)`n"
}

$document = ($frontMatter -join "`n") + "`n" + $body.TrimEnd("`n") + "`n"

if ($PSBoundParameters.ContainsKey('OutputPath')) {
    $outputDirectory = Split-Path -Parent $OutputPath
    if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }
    [IO.File]::WriteAllText($OutputPath, $document, [Text.UTF8Encoding]::new($false))
    Write-Host "[HOMEPAGE] Wrote $OutputPath" -ForegroundColor Green
}
else {
    $document
}
