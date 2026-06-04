#=================================================================================================================
#                Accessibility > Narrator > Verbosity Level > Change How Capitalized Text Is Read
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorCapitalizationReadingMode
        [-Mode] {NoAnnounce | IncreasePitch | SayCap}
        [<CommonParameters>]
#>

function Set-NarratorCapitalizationReadingMode
{
    <#
    .EXAMPLE
        PS> Set-NarratorCapitalizationReadingMode -Mode 'NoAnnounce'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NarratorCapitalizationReadingMode] $Mode
    )

    process
    {
        # NoAnnounce: 0 (default) | IncreasePitch: 1 | SayCap: 2
        $NarratorCapitalizationReadingMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'CapitalizationReading'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Verbosity Level: Change How Capitalized Text Is Read' to '$Mode' ..."
        Set-RegistryEntry -InputObject $NarratorCapitalizationReadingMode
    }
}
