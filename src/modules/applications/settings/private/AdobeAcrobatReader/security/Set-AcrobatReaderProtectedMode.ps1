#=================================================================================================================
#                       Acrobat Reader - Preferences > Security > Protected Mode At Startup
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderProtectedMode
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderProtectedMode
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderProtectedMode -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $AcrobatReaderProtectedMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\Privileged'
            Entries = @(
                @{
                    Name  = 'bProtectedMode'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Protected Mode At Startup' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderProtectedMode
    }
}
