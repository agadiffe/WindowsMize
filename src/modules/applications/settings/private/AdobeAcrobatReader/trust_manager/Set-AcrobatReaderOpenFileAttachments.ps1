#=================================================================================================================
#            Acrobat Reader - Preferences > Trust Manager > Allow Opening Of Non-PDF File Attachments
#=================================================================================================================

# Attachments represent a potential security risk because they can contain malicious content,
# open other dangerous files, or launch applications.
# This feature prevents users from opening or launching file types other than PDF or FDF.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-AcrobatReaderOpenFileAttachments
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderOpenFileAttachments
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderOpenFileAttachments -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $OpenFileAttachmentsMsg = 'Acrobat Reader - Allow Opening Of Non-PDF File Attachments'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $AcrobatReaderOpenFileAttachments = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\Originals'
                    Entries = @(
                        @{
                            Name  = 'bAllowOpenFile'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$OpenFileAttachmentsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderOpenFileAttachments
            }
            'GPO'
            {
                # Not really a GPO, but achieve the same result by graying out the GUI setting.

                # gpo\ Originals (General Application Settings) > Attachments
                #   specifies whether to allow opening attachments which are not PDF
                # not configured: delete (default) | off: 1
                $AcrobatReaderOpenFileAttachmentsGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\Originals'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'bSecureOpenFile'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$OpenFileAttachmentsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderOpenFileAttachmentsGpo
            }
        }
    }
}
