#=================================================================================================================
#                                                    HomeGroup
#=================================================================================================================

<#
.SYNTAX
    Set-HomeGroup
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-HomeGroup
{
    <#
    .EXAMPLE
        PS> Set-HomeGroup -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > homegroup
        #   prevent the computer from joining a homegroup
        # not configured: delete (default) | on: 1
        $HomeGroupGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\HomeGroup'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableHomeGroup'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'HomeGroup (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $HomeGroupGpo
    }
}
