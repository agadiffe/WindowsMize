#=================================================================================================================
#             Accessibility > Mouse > Amount Of Time Mouse Needs To Be Over A Windows To Activate It
#=================================================================================================================

<#
.SYNTAX
    Set-MouseActivateOnHoverDelay
        [-Level] <int>
        [<CommonParameters>]
#>

function Set-MouseActivateOnHoverDelay
{
    <#
    .EXAMPLE
        PS> Set-MouseActivateOnHoverDelay -Level 5
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 9)]
        [int] $Level
    )

    process
    {
        # default: 500 (range: 100-900)
        $ActivateOnHoverDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'ActiveWndTrkTimeout'
                    Value = $Level * 100
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Amount Of Time Mouse Needs To Be Over A Windows To Activate It' to 'Level: $Level' ..."
        Set-RegistryEntry -InputObject $ActivateOnHoverDelay
    }
}
