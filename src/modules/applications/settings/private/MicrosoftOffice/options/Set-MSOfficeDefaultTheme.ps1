#=================================================================================================================
#                                   MSOffice - Options > General > Office Theme
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeDefaultTheme
        [-GPO] {Colorful | DarkGray | Black | White | NotConfigured}
        [<CommonParameters>]
#>

function Set-MSOfficeDefaultTheme
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeDefaultTheme -GPO 'Office'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [OfficeThemeGpo] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > microsoft office > global options > customize
        #   default Office theme
        # not configured: delete (default) | on: Colorful (0), DarkGray (1), Black (2), White (3) 
        $MSOfficeTheme = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'default ui theme'
                    Value = [int]$GPO
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Default Theme (GPO) (if none selected)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $MSOfficeTheme
    }
}
