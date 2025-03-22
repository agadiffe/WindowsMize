#=================================================================================================================
#                               Personnalization > Taskbar > Taskbar Items > Search
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarSearchBox
        [[-Value] {Hide | IconOnly | Box | IconAndLabel}]
        [-GPO {Hide | IconOnly | Box | IconAndLabel | NotConfigured}]
        [<CommonParameters>]
#>

function Set-TaskbarSearchBox
{
    <#
    .EXAMPLE
        PS> Set-TaskbarSearchBox -Value 'Hide' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [SearchBoxMode] $Value,

        [GpoSearchBoxMode] $GPO
    )

    process
    {
        $TaskbarSearchBoxMsg = 'Taskbar Items - Search'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # hide: 0 | search icon only: 1 | search box: 2 (default) | search icon and label: 3
                $TaskbarSearchBox = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Search'
                    Entries = @(
                        @{
                            Name  = 'SearchboxTaskbarMode'
                            Value = [int]$Value
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TaskbarSearchBoxMsg' to '$Value' ..."
                Set-RegistryEntry -InputObject $TaskbarSearchBox
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > search
                #   configures search on the taskbar
                # not configured: delete (default) | value: same as 'State'
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
