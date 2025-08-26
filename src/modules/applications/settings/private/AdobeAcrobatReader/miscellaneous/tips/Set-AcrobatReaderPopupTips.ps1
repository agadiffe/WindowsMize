#=================================================================================================================
#                                   Acrobat Reader - Miscellaneous > Popup Tips
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderPopupTips
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderPopupTips
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderPopupTips -GPO 'Disabled'
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

        # gpo\ AVGeneral (General Preferences) > Tools Customization
        #   specifies whether the popup tooltips for the Tools, Comments, and Share panes should appear
        # not configured: delete (default) | off: 0
        #
        # gpo\ FeatureLockDown (Lockable Settings) > Context menus, tips, tools
        #   controls whether to automatically display help tips based on the current context
        # not configured: delete (default) | off: 0
        #
        # gpo\ FeatureLockDown (Lockable Settings) > Services-Reviews (DC)
        #   specifies whether to display a Share/Review feature reminder message when users have used those features in the past
        # not configured: delete (default) | off: 0
        $AcrobatReaderPopupTipsGpo = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bInfobubble'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                Entries = @(
                    @{
                        RemoveEntry = $GPO -eq 'NotConfigured'
                        Name  = 'bEnableContextualTips'
                        Value = '0'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $GPO -eq 'NotConfigured'
                        Name  = 'bEnableReviewPromote'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Acrobat Reader - Popup Tips (GPO)' to '$GPO' ..."
        $AcrobatReaderPopupTipsGpo | Set-RegistryEntry
    }
}
