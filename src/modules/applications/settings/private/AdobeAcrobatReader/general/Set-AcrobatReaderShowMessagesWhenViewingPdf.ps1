#=================================================================================================================
#              Acrobat Reader - Preferences > General > Don't Show Messages While Viewing A Document
#=================================================================================================================

# These messages may include information about other products, features, or services,
# including UI which promotes Acrobat.

# The GUI preference doesn't seem to do anything (bug or feature ?).
# Use the group policy to disable this setting.

# e.g. Disable this setting to hide the "Free Trial" button/message.

<#
.SYNTAX
    Set-AcrobatReaderShowMessagesWhenViewingPdf
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderShowMessagesWhenViewingPdf
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderShowMessagesWhenViewingPdf -State 'Disabled' -GPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $ShowMsgWhenViewingPdfMsg = 'Acrobat Reader - Show Messages While Viewing A Document'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 0 (default) | off: 1
                $AcrobatReaderShowMsgWhenViewingPdf = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\IPM'
                    Entries = @(
                        @{
                            Name  = 'bDontShowMsgWhenViewingDoc'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ShowMsgWhenViewingPdfMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderShowMsgWhenViewingPdf
            }
            'GPO'
            {
                # gpo\ IPM (In product messaging)
                #   specifies whether to show messages from Adobe when a document opens
                # not configured: delete (default) | on: 1 | off: 0
                $AcrobatReaderShowMsgWhenViewingPdfGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cIPM'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'bDontShowMsgWhenViewingDoc'
                            Value = $GPO -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ShowMsgWhenViewingPdfMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderShowMsgWhenViewingPdfGpo
            }
        }
    }
}
