# Enable Vi mode
Set-PSReadlineOption -EditMode Vi -ViModeIndicator Prompt

# Custom mappings (set `Get-PSReadLineKeyHandler`)
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward

# Prompt
try {
    oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\marcduiker.omp.json | Invoke-Expression
}
catch {
    Write-Host 'Failed to invoke oh-my-posh.'
    Write-Host $_
}
