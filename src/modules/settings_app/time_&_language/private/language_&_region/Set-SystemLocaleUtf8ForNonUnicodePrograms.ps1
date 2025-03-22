#=================================================================================================================
#           Time & Language > Language & Region > Administrative Language Settings > Use Unicode UTF-8
#=================================================================================================================

# Language for non-Unicode programs. i.e. For (very) old/legacy programs.
# Change system locale > Beta: Use Unicode UTF-8 for worldwide language support.

<#
.SYNTAX
    Set-SystemLocaleUtf8ForNonUnicodePrograms
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SystemLocaleUtf8ForNonUnicodePrograms
{
    <#
    .EXAMPLE
        PS> Set-SystemLocaleUtf8ForNonUnicodePrograms -State 'Enabled'
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
        $SystemLocaleTextInfo = (Get-WinSystemLocale).TextInfo

        # default (for most system): 1252 1000 437 | UTF-8: 65001
        $SystemLocaleUtf8 = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Nls\CodePage'
            Entries = @(
                @{
                    Name  = 'ACP'
                    Value = $IsEnabled ? '65001' : $SystemLocaleTextInfo.ANSICodePage
                    Type  = 'String'
                }
                @{
                    Name  = 'MACCP'
                    Value = $IsEnabled ? '65001' : $SystemLocaleTextInfo.MacCodePage
                    Type  = 'String'
                }
                @{
                    Name  = 'OEMCP'
                    Value = $IsEnabled ? '65001' : $SystemLocaleTextInfo.OEMCodePage
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Language & Region - Use Unicode UTF-8 For Non-Unicode Programs' to '$State' ..."
        Set-RegistryEntry -InputObject $SystemLocaleUtf8
    }
}
