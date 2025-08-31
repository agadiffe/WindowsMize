#=================================================================================================================
#       System > Optional Features > More Windows Features - Export Enabled Windows Optional Features Names
#=================================================================================================================

<#
.SYNTAX
    Export-EnabledWindowsOptionalFeaturesNames [<CommonParameters>]
#>

function Export-EnabledWindowsOptionalFeaturesNames
{
    [CmdletBinding()]
    param ()

    process
    {
        $LogFilePath = "$PSScriptRoot\..\..\..\..\..\log\windows_default_optional_features_names.txt"
        if (-not (Test-Path -Path $LogFilePath))
        {
            Write-Verbose -Message 'Exporting Enabled Windows Optional Features Names ...'

            New-ParentPath -Path $LogFilePath

            Get-WindowsOptionalFeature -Online -Verbose:$false |
                Where-Object -Property 'State' -EQ -Value 'Enabled' |
                Select-Object -ExpandProperty 'FeatureName' |
                Sort-Object |
                Out-File -FilePath $LogFilePath
        }
    }
}
