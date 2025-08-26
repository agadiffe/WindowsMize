#=================================================================================================================
#                                 Acrobat Reader - Miscellaneous > Outlook Plugin
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderOutlookPlugin
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderOutlookPlugin
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderOutlookPlugin -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ Workflows (Services integration) > DC Send and Track
        #   toggles the Adobe Send and Track plugin for Outlook
        # not configured: delete (default) | off: 1
        $AcrobatReaderOutlookPluginGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cCloud'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bAdobeSendPluginToggle'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Outlook Plugin (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderOutlookPluginGpo
    }
}
