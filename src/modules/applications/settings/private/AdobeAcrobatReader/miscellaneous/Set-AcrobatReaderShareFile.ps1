#=================================================================================================================
#                                   Acrobat Reader - Miscellaneous > Share File
#=================================================================================================================

# This setting will replace the Share Icon with the Email Icon.

<#
.SYNTAX
    Set-AcrobatReaderShareFile
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderShareFile
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderShareFile -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ FeatureLockDown (Lockable Settings) > Services (Unified Share)
        #   disables Adobe Send and Track (some UI is renamed to "Share")
        # not configured: delete (default) | off: 0
        $AcrobatReaderShareFileGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bToggleSendAndTrack'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Share File (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderShareFileGpo
    }
}
