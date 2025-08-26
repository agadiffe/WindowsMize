#=================================================================================================================
#                             Acrobat Reader - Miscellaneous > Crash Reporter Dialog
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderCrashReporterDialog
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderCrashReporterDialog
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderCrashReporterDialog -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ FeatureLockDown (Lockable Settings) > Miscellaneous Features
        #   specifies whether to show the crash reporter dialog on application crash (Windows only)
        # not configured: delete (default) | off: 0
        $AcrobatReaderCrashReporterDialogGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bCrashReporterEnabled'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Crash Reporter Dialog (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderCrashReporterDialogGpo
    }
}
