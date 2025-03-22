#=================================================================================================================
#                       Windows Update > Windows Insider Program > Setting Page Visibility
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdateInsiderProgramPageVisibility
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinUpdateInsiderProgramPageVisibility
{
    <#
    .EXAMPLE
        PS> Set-WinUpdateInsiderProgramPageVisibility -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete (default) | off: 1
        $WinUpdateInsiderProgramPageVisibility = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\WindowsSelfHost\UI\Visibility'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Disabled'
                    Name  = 'HideInsiderPage'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Insider Program - Page Visibility' to '$State' ..."
        Set-RegistryEntry -InputObject $WinUpdateInsiderProgramPageVisibility
    }
}
