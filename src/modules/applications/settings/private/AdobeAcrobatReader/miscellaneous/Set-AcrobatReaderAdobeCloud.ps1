#=================================================================================================================
#                                  Acrobat Reader - Miscellaneous > Adobe Cloud
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderAdobeCloud
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderAdobeCloud
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAdobeCloud -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $AcrobatReaderAdobeCloud = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cCloud'
            Entries = @(
                @{
                    Name  = 'bDisableADCFileStore'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Adobe Cloud' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderAdobeCloud
    }
}
