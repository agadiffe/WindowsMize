#=================================================================================================================
#                                          Online Tips (in Settings app)
#=================================================================================================================

<#
.SYNTAX
    Set-OnlineTips
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-OnlineTips
{
    <#
    .EXAMPLE
        PS> Set-OnlineTips -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > control panel
        #   allow online tips
        # not configured: delete (default) | off: 0
        $OnlineTipGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AllowOnlineTips'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Online Tips (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $OnlineTipGpo
    }
}
