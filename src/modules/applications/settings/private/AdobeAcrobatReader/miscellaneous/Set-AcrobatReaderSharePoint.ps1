#=================================================================================================================
#                                   Acrobat Reader - Miscellaneous > SharePoint
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderSharePoint
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderSharePoint
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderSharePoint -State 'Disabled'
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
        $AcrobatReaderSharePoint = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cCloud'
            Entries = @(
                @{
                    Name  = 'bDisableSharePointFeatures'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - SharePoint' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderSharePoint
    }
}
