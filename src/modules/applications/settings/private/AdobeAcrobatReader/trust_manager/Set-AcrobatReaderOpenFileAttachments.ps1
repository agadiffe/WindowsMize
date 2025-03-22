#=================================================================================================================
#                  Acrobat Reader - Preferences > Trust Manager > Allow Opening File Attachments
#=================================================================================================================

# Attachments represent a potential security risk because they can contain malicious content,
# open other dangerous files, or launch applications.
# This feature prevents users from opening or launching file types other than PDF or FDF.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-AcrobatReaderOpenFileAttachments
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderOpenFileAttachments
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderOpenFileAttachments -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # allow opening of non-PDF file attachments with external applications
        # on: 1 (default) | off: 0
        #
        # allow opening of non-PDF file attachments (gray out the above setting) (no GUI item)
        # on: 0 (default) | off: 1
        $AcrobatReaderOpenFileAttachments = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\Originals'
            Entries = @(
                @{
                    Name  = 'bAllowOpenFile'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'bSecureOpenFile'
                    Value = $IsEnabled ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Allow Opening Of Non-PDF File Attachments' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderOpenFileAttachments
    }
}
