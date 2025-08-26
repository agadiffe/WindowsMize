#=================================================================================================================
#                                  Acrobat Reader - Miscellaneous > Accept EULA
#=================================================================================================================

# EULA : End-User License Agreement

<#
.SYNTAX
    Set-AcrobatReaderAcceptEULA
        [-GPO] {Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderAcceptEULA
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAcceptEULA -GPO 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutDisabled] $GPO
    )

    process
    {
        # gpo\ AdobeViewer (PDF Viewer Settings) > EULA acceptance
        #   for Reader, indicates whether the EULA has been accepted
        #   for Acrobat's browser plugin, caches whether the browser-based EULA has been accepted
        # not configured: delete (default) | on: 1
        $AcrobatReaderCrashReporterDialogGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\AdobeViewer'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'EULA'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'EULAAcceptedForBrowser'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Accept EULA (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderCrashReporterDialogGpo
    }
}
