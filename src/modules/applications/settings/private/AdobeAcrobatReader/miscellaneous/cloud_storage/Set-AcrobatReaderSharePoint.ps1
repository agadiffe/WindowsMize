#=================================================================================================================
#                                   Acrobat Reader - Miscellaneous > SharePoint
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderSharePoint
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderSharePoint
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderSharePoint -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ Workflows (Services integration) > Services (SharePoint-Office365)
        #   disables the SharePoint and Office 365 integration features
        # not configured: delete (default) | off: 1
        $AcrobatReaderSharePointGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cCloud'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bDisableSharePointFeatures'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - SharePoint (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderSharePointGpo
    }
}
