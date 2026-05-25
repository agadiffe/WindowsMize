#=================================================================================================================
#                  Accessibility > Mouse > Amount Of Time Mouse Button Needs To Be Down To Lock
#=================================================================================================================

<#
.SYNTAX
    Set-MouseClickLockDelay
        [-Level] <int>
        [<CommonParameters>]
#>

function Set-MouseClickLockDelay
{
    <#
    .EXAMPLE
        PS> Set-MouseClickLockDelay -Level 6
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 11)]
        [int] $Level
    )

    process
    {
        # default: 1200 (range: 200-2200)
        $MouseClickLockDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'ClickLockTime'
                    Value = $Level * 200
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Amount Of Time Mouse Button Needs To Be Down To Lock' to 'Level: $Level' ..."
        Set-RegistryEntry -InputObject $MouseClickLockDelay
    }
}
