#=================================================================================================================
#                                     Accessibility > Narrator > Math Reading
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathReading
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorMathReading
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathReading -State 'Enabled'
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
        $NarratorMathReading = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathReadingEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorMathReading
    }
}
