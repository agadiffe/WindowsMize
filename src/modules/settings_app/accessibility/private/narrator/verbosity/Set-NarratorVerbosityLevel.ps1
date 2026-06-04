#=================================================================================================================
#                                   Accessibility > Narrator > Verbosity Level
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorVerbosityLevel
        [-Mode] {TextOnly | SomeControlDetails | AllControlDetails | SomeTextDetails | AllTextDetails}
        [<CommonParameters>]
#>

function Set-NarratorVerbosityLevel
{
    <#
    .EXAMPLE
        PS> Set-NarratorVerbosityLevel -Mode 'AllControlDetails'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NarratorVerbosityLevel] $Mode
    )

    process
    {
        # TextOnly: 1 | SomeControlDetails: 2 | AllControlDetails: 3 (default) | SomeTextDetails: 4 | AllTextDetails: 5
        $NarratorVerbosityLevel = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'UserVerbosityLevel'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Verbosity Level' to '$Mode' ..."
        Set-RegistryEntry -InputObject $NarratorVerbosityLevel
    }
}
