#=================================================================================================================
#                          Acrobat Reader - Miscellaneous > Online Services And Features
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderOnlineServices
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderOnlineServices
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderOnlineServices -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # bAdobeSendPluginToggle\ on: 0 | off: 1 (default)
        # bToggleXXXXX\ on: 0 (default) | off: 1
        # bUpdater\ on: 1 (default) | off: 0
        $AcrobatReaderOnlineServices = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices'
            Entries = @(
                @{
                    Name  = 'bAdobeSendPluginToggle'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bToggleAdobeDocumentServices'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bToggleAdobeSign'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bTogglePrefSync'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bToggleWebConnectors'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bUpdater'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Online Services And Features' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderOnlineServices
    }
}
