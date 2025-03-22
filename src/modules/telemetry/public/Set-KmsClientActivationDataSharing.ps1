#=================================================================================================================
#                                     Telemetry - KMS Client Activation Data
#=================================================================================================================

# Prevents sending KMS client activation data to Microsoft automatically.

# CIS recommendation: Disabled

<#
.SYNTAX
    Set-KmsClientActivationDataSharing
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-KmsClientActivationDataSharing
{
    <#
    .EXAMPLE
        PS> Set-KmsClientActivationDataSharing -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > software protection platform
        #   turn off KMS client online AVS validation
        # not configured: delete (default) | on: 1
        $KmsClientActivationGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'NoGenTicket'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'KMS Client Activation Data Sharing (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $KmsClientActivationGpo
    }
}
