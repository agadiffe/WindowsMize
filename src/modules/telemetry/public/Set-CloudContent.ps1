#=================================================================================================================
#                                            Telemetry - Cloud Content
#=================================================================================================================

# Due to privacy concerns, data should never be sent to any 3rd party since this
# data could contain sensitive information.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-CloudContent
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-CloudContent
{
    <#
    .EXAMPLE
        PS> Set-CloudContent -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ computer config > administrative tpl > windows components > cloud content
        #   turn off cloud optimized content
        #   turn off cloud consumer account state content
        # not configured: delete (default) | on: 1
        $CloudContentGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\CloudContent'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableCloudOptimizedContent'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'DisableConsumerAccountStateContent'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Cloud Content (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $CloudContentGpo
    }
}
