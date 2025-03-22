#=================================================================================================================
#       System > Optional Features > More Windows Features - Export Enabled Windows Optional Features Names
#=================================================================================================================

function Export-EnabledWindowsOptionalFeaturesNames
{
    $LogFilePath = "$PSScriptRoot\..\..\..\..\..\log\windows_optional_features_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Enabled Windows Optional Features Names ...'

        Get-WindowsOptionalFeature -Online -Verbose:$false |
            Where-Object -Property 'State' -EQ -Value 'Enabled' |
            Select-Object -ExpandProperty 'FeatureName' |
            Sort-Object |
            Out-File -FilePath $LogFilePath
    }
}
