#=================================================================================================================
#                                                    Help Tips
#=================================================================================================================

<#
.SYNTAX
    Set-HelpTips
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-HelpTips
{
    <#
    .EXAMPLE
        PS> Set-HelpTips -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > edge ui
        #   disable help tips
        # not configured: delete (default) | on: 1
        $HelpTipsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\EdgeUI'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableHelpSticker'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Help Tips (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $HelpTipsGpo
    }
}
