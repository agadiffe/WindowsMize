#=================================================================================================================
#                Accessibility > Narrator > Get Image Descriptions, Page Titles, And Popular Links
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorContentDescriptions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorContentDescriptions
{
    <#
    .EXAMPLE
        PS> Set-NarratorContentDescriptions -State 'Enabled'
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
        $NarratorContentDescriptions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'OnlineServicesEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Get Image Descriptions, Page Titles, And Popular Links' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorContentDescriptions
    }
}
