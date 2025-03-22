#=================================================================================================================
#                                      Remove Preinstalled Optional Feature
#=================================================================================================================

# Some Windows Capabilities are no longer installed by default.
# e.g. Print.Fax.Scan, WMIC, Microsoft.Windows.WordPad, XPS.Viewer

class PreinstalledOptionalFeatures : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return $Script:WindowsCapabilitiesList.Keys + $Script:WindowsOptionalFeaturesList.Keys
    }
}

<#
.SYNTAX
    Remove-PreinstalledOptionalFeature
        [-Name] {ExtendedThemeContent | FacialRecognitionWindowsHello | InternetExplorerMode | MathRecognizer |
                NotepadSystem | OneSync | OpenSSHClient | PrintManagement | StepsRecorder | WMIC | VBScript |
                WindowsFaxAndScan | WindowsMediaPlayerLegacy | WindowsPowerShellISE | WordPad | XpsViewer |
                InternetPrintingClient | MediaFeatures | MicrosoftXpsDocumentWriter | NetFramework48TcpPortSharing |
                RemoteDesktopConnection | RemoteDiffCompressionApiSupport | SmbDirect | WindowsPowerShell2 |
                WindowsRecall | WorkFoldersClient}
        [<CommonParameters>]
#>

function Remove-PreinstalledOptionalFeature
{
    <#
    .EXAMPLE
        PS> $FeaturesToRemove = @(
                'ExtendedThemeContent'
                'NotepadSystem'
                'WindowsMediaPlayerLegacy'
                'InternetPrintingClient'
                'WindowsPowerShell2'
            )
        PS> $FeaturesToRemove | Remove-PreinstalledOptionalFeature
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet([PreinstalledOptionalFeatures])]
        [string] $Name
    )

    process
    {
        switch ($Name)
        {
            { $WindowsCapabilitiesList.Contains($_) }
            {
                $WindowsCapabilitiesList.$_ | Set-WindowsCapability -State 'Disabled'
            }
            { $WindowsOptionalFeaturesList.Contains($_) }
            {
                $WindowsOptionalFeaturesList.$_ | Set-WindowsOptionalFeature -State 'Disabled'
            }
        }
    }
}
