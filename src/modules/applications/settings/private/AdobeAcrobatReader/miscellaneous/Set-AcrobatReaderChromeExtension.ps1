#=================================================================================================================
#                                Acrobat Reader - Miscellaneous > Chrome Extension
#=================================================================================================================

# The Chrome extension is automatically installed ...

<#
.SYNTAX
    Set-AcrobatReaderChromeExtension
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderChromeExtension
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderChromeExtension -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ FeatureLockDown (Lockable Settings) > Chrome Integration
        #   specifies whether to install the Chrome extension for PDF viewing
        # not configured: delete (default) | on: 1 | off: 0
        $AcrobatReaderChromeExtensionGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Adobe\Adobe Acrobat\DC\Installer'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'ENABLE_CHROMEEXT'
                    Value = $GPO -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Chrome Extension (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderChromeExtensionGpo
    }
}
