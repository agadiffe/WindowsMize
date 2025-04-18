#=================================================================================================================
#                                                     Recall
#=================================================================================================================

<#
.SYNTAX
    Set-Recall
        [-GPO] {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-Recall
{
    <#
    .EXAMPLE
        PS> Set-Recall -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > windows AI​
        #   allow Recall to be enabled
        # not configured: delete (default) | on: 1 | off: 0

        $WindowsRecallGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsAI'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AllowRecallEnablement'
                    Value = $GPO -eq 'NotConfigured' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Recall (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WindowsRecallGpo
    }
}
