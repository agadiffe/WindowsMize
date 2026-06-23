#=================================================================================================================
#                              MSOffice - Options > Save > Save Files In This Format
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeDefaultFileFormat
        [-FileFormat] {Office | OpenDocument}
        [<CommonParameters>]
#>

function Set-MSOfficeDefaultFileFormat
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeDefaultFileFormat -FileFormat 'Office'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [OfficeFileFormat] $FileFormat
    )

    process
    {
        $IsOfficeFileFormat = $FileFormat -eq 'Office'

        # Office Open XML formats: 51 27 empty (default) | OpenDocument formats: 60 52 ODT
        $MSOfficeDefaultFileFormat = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Excel\Options'
                Entries = @(
                    @{
                        Name  = 'DefaultFormat'
                        Value = $IsOfficeFileFormat ? '51' : '60'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\PowerPoint\Options'
                Entries = @(
                    @{
                        Name  = 'DefaultFormat'
                        Value = $IsOfficeFileFormat ? '27' : '52'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Office\16.0\Word\Options'
                Entries = @(
                    @{
                        Name  = 'DefaultFormat'
                        Value = $IsOfficeFileFormat ? '' : 'ODT'
                        Type  = 'String'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'MSOffice - Default File Format' to '$FileFormat' ..."
        $MSOfficeDefaultFileFormat | Set-RegistryEntry
    }
}
