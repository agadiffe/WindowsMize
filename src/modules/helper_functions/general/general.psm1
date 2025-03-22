$VerbosePreference = $Global:ModuleVerbosePreference

$FunctionsPath = @(
    "$PSScriptRoot\classes"
    "$PSScriptRoot\private"
    "$PSScriptRoot\public"
)

Get-ChildItem -Path $FunctionsPath -Filter '*.ps1' -Recurse -ErrorAction 'SilentlyContinue' |
    ForEach-Object -Process { . $_.FullName }
