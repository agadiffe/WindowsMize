#=================================================================================================================
#                               Personnalization > Taskbar > Taskbar Items > Search
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarSearchBox
        [[-Mode] {Hide | IconOnly | Box | IconAndLabel}]
        [-GPO {Hide | IconOnly | Box | IconAndLabel | NotConfigured}]
        [<CommonParameters>]
#>

function Set-TaskbarSearchBox
{
    <#
    .EXAMPLE
        PS> Set-TaskbarSearchBox -Mode 'Hide' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [SearchBoxMode] $Mode,

        [GpoSearchBoxMode] $GPO
    )

    process
    {
        $TaskbarSearchBoxMsg = 'Taskbar Items - Search'

        switch ($PSBoundParameters.Keys)
        {
            'Mode'
            {
                # hide: 0 | search icon only: 1 | search box: 2 (default) | search icon and label: 3
                $TaskbarSearchBox = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Search'
                    Entries = @(
                        @{
                            Name  = 'SearchboxTaskbarMode'
                            Value = [int]$Mode
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarSearchBoxMsg' to '$Mode' ..."
                Set-RegistryEntry -InputObject $TaskbarSearchBox
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > search
                #   configures search on the taskbar
                # not configured: delete (default) | hide: 0 | search icon only: 1
                # search box: 2 (default) | search icon and label: 3
                $TaskbarSearchBoxGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\Windows Search'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'SearchOnTaskbarMode'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarSearchBoxMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $TaskbarSearchBoxGpo
            }
        }
    }
}
