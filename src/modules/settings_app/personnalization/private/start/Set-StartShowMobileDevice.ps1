#=================================================================================================================
#                             Personnalization > Start > Show Mobile Device In Start
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowMobileDevice
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartShowMobileDevice
{
    <#
    .EXAMPLE
        PS> Set-StartShowMobileDevice -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $StartMobileDevice = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start\Companions\Microsoft.YourPhone_8wekyb3d8bbwe'
            Entries = @(
                @{
                    Name  = 'IsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Show Mobile Device In Start' to '$State' ..."
        Set-RegistryEntry -InputObject $StartMobileDevice
    }
}
