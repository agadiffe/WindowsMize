#=================================================================================================================
#                                               Gaming > Xbox Mode
#=================================================================================================================

<#
.SYNTAX
    Set-XboxMode
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-XboxMode
{
    <#
    .EXAMPLE
        PS> Set-XboxMode -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: Microsoft.GamingApp_8wekyb3d8bbwe!Microsoft.Xbox.App (default) | off: empty value
        $XboxMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\GamingConfiguration'
            Entries = @(
                @{
                    Name  = 'GamingHomeApp'
                    Value = $State -eq 'Enabled' ? 'Microsoft.GamingApp_8wekyb3d8bbwe!Microsoft.Xbox.App' : ''
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Gaming - Xbox Mode' to '$State' ..."
        Set-RegistryEntry -InputObject $XboxMode
    }
}
