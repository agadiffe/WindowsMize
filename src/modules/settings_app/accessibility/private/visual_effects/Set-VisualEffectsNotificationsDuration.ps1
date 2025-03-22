#=================================================================================================================
#                Accessibility > Visual Effects > Dismiss Notifications After This Amount Of Time
#=================================================================================================================

<#
.SYNTAX
    Set-VisualEffectsNotificationsDuration
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-VisualEffectsNotificationsDuration
{
    <#
    .EXAMPLE
        PS> Set-VisualEffectsNotificationsDuration -Value 5
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(5, 7, 15, 30, 60, 300)]
        [int] $Value
    )

    process
    {
        # value are in second
        # default (and minimum): 5
        $VisualEffectsNotificationsDuration = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility'
            Entries = @(
                @{
                    Name  = 'MessageDuration'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Visual Effects - Dismiss Notifications After This Amount Of Time' to '$Value' ..."
        Set-RegistryEntry -InputObject $VisualEffectsNotificationsDuration
    }
}
