#=================================================================================================================
#                           Acrobat Reader - Miscellaneous > Third Party Cloud Storage
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderThirdPartyCloudStorage
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderThirdPartyCloudStorage
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderThirdPartyCloudStorage -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ FeatureLockDown (Lockable Settings) > Services-Cloud Storage (DC)
        #   specifies whether to enable cloud storage connectors
        # not configured: delete (default) | off: 1
        $AcrobatReaderThirdPartyCloudStorageGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bToggleWebConnectors'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Third Party Cloud Storage (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderThirdPartyCloudStorageGpo
    }
}
