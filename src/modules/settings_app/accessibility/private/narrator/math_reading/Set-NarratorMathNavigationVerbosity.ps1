#=================================================================================================================
#                         Accessibility > Narrator > Math Reading > Navigation Verbosity
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathNavigationVerbosity
        [-Mode] {Terse | Medium | Verbose}
        [<CommonParameters>]
#>

function Set-NarratorMathNavigationVerbosity
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathNavigationVerbosity -Mode 'Medium'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [MathReadingVerbosityLevel] $Mode
    )

    process
    {
        # Terse | Medium (default) | Verbose
        $NarratorMathNavigationVerbosity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathNavigationVerbosity'
                    Value = $Mode
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading: Navigation Verbosity' to '$Mode' ..."
        Set-RegistryEntry -InputObject $NarratorMathNavigationVerbosity
    }
}
