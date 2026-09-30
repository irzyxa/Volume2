<#
.SYNOPSIS
  Writes the .lng language files from Translate.xlsx.

.DESCRIPTION
  Sheet MainTranslate holds everything: column A the keys ([Section] lines, key names, empty lines), one column per
  language with that language's texts, and in row 1 the base name of the language's file (English -> English.lng).
  Cell A1 is the first line of every file. For each language column a line is "[Section]" for a section row,
  "key=text" for a key row and empty for an empty row - the same lines the old per-language formula sheets built.
  Files are written as UTF-8 without BOM, CRLF line endings, exactly as the cells read; empty rows at the end are left out.
  The workbook is opened read-only with macros disabled. Needs Microsoft Excel.

.EXAMPLE
  .\ExportLng.ps1                  # export all languages next to the workbook
  .\ExportLng.ps1 -WhatIf          # only report which files would change
#>
[CmdletBinding(SupportsShouldProcess)]
param(
  [string]$Workbook,
  [string]$OutDir,
  [string]$SourceSheet = 'MainTranslate'
)
$ErrorActionPreference = 'Stop'
# Windows PowerShell leaves $PSScriptRoot empty in parameter defaults, so the defaults are set here
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $Workbook) { $Workbook = Join-Path $scriptDir 'Translate.xlsx' }
if (-not $OutDir) { $OutDir = $scriptDir }
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$excel = New-Object -ComObject Excel.Application
try {
  $excel.Visible = $false
  $excel.DisplayAlerts = $false
  $excel.AutomationSecurity = 3   # msoAutomationSecurityForceDisable: no macros run
  $wb = $excel.Workbooks.Open((Resolve-Path $Workbook).Path, 0, $true)
  try {
    $ws = $wb.Worksheets.Item($SourceSheet)
    $rows = $ws.UsedRange.Row + $ws.UsedRange.Rows.Count - 1
    $cols = $ws.UsedRange.Column + $ws.UsedRange.Columns.Count - 1
    $v = $ws.Range($ws.Cells.Item(1, 1), $ws.Cells.Item($rows, $cols)).Value2
  }
  finally { $wb.Close($false) }
}
finally {
  $excel.Quit()
  [void][Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
  # Excel only exits once every COM reference PowerShell still holds is released
  [GC]::Collect()
  [GC]::WaitForPendingFinalizers()
}

function CellText($value, [int]$row, [int]$col) {
  # A formula error comes back as an Int32 error code, never as text
  if ($value -is [int]) { throw "row $row, column ${col}: formula error ($value)" }
  [string]$value
}

$header = CellText $v[1, 1] 1 1
for ($c = 2; $c -le $cols; $c++) {
  $name = (CellText $v[1, $c] 1 $c).Trim()
  if ($name -eq '') { continue }
  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add($header)
  for ($r = 2; $r -le $rows; $r++) {
    $key = CellText $v[$r, 1] $r 1
    if ($key.StartsWith('[')) { $lines.Add($key) }
    elseif ($key -ne '') { $lines.Add($key + '=' + (CellText $v[$r, $c] $r $c)) }
    else { $lines.Add('') }
  }
  # Empty rows at the end of the sheet are not lines of the file
  while ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq '') { $lines.RemoveAt($lines.Count - 1) }
  $file = Join-Path $OutDir "$name.lng"
  $new = $utf8NoBom.GetBytes(($lines -join "`r`n") + "`r`n")
  $old = if (Test-Path $file) { [IO.File]::ReadAllBytes($file) } else { $null }
  $changed = ($null -eq $old) -or ($old.Length -ne $new.Length) -or (Compare-Object $old $new -SyncWindow 0)
  if (-not $changed) { Write-Output ('unchanged  {0}' -f (Split-Path $file -Leaf)); continue }
  if ($PSCmdlet.ShouldProcess($file, 'Write language file')) {
    [IO.File]::WriteAllBytes($file, $new)
    Write-Output ('written    {0}  ({1} lines)' -f (Split-Path $file -Leaf), $lines.Count)
  }
}
