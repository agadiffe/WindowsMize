#=================================================================================================================
#                                    MSOffice - Misc > Show File Format Dialog
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeShowFileFormatDialog
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeShowFileFormatDialog
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeShowFileFormatDialog -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
        #   show the file format dialog
        # not configured: delete (default) | off: 1
        $MSOfficeFileFormatDialog = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Registration'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'ShownFileFmtPromptPolicy'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Show File Format Dialog (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeFileFormatDialog
    }
}
