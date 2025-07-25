#=================================================================================================================
#                            System > Notifications > Position Of On-Screen Indicators
#=================================================================================================================

<#
.SYNTAX
    Set-NotificationsScreenIndicatorsPosition
        [-Value] {BottomCenter | TopLeft | TopCenter}
        [<CommonParameters>]
#>

function Set-NotificationsScreenIndicatorsPosition
{
    <#
    .EXAMPLE
        PS> Set-NotificationsScreenIndicatorsPosition -Value 'BottomCenter'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NotifsPositionIndex] $Value
    )

    process
    {
        # BottomCenter: 1 (default) | TopLeft: 2 | TopCenter: 3
        $NotificationsScreenIndicatorsPosition = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Notifications\Settings'
            Entries = @(
                @{
                    Name  = 'PositionIndex'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Notifications - Position Of On-Screen Indicators' to '$Value' ..."
        Set-RegistryEntry -InputObject $NotificationsScreenIndicatorsPosition
    }
}
