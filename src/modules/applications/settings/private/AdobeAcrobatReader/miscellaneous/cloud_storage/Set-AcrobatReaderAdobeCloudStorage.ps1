#=================================================================================================================
#                              Acrobat Reader - Miscellaneous > Adobe Cloud Storage
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderAdobeCloudStorage
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderAdobeCloudStorage
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAdobeCloudStorage -GPO 'Disabled'
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
        #   specifies whether to enable Document Cloud storage
        # not configured: delete (default) | off: 1
        $AcrobatReaderAdobeCloudStorageGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bToggleDocumentCloud'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Adobe Cloud Storage (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderAdobeCloudStorageGpo
    }
}
