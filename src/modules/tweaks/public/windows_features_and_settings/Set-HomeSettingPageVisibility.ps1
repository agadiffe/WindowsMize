#=================================================================================================================
#                                          Home Setting Page Visibility
#=================================================================================================================

<#
.SYNTAX
    Set-HomeSettingPageVisibility
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-HomeSettingPageVisibility
{
    <#
    .EXAMPLE
        PS> Set-HomeSettingPageVisibility -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $RegPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        $CurrentSettings = (Get-ItemProperty -Path $RegPath -ErrorAction 'SilentlyContinue').SettingsPageVisibility

        $PageVisibility = switch -Regex ($CurrentSettings)
        {
            '^hide:.*home' { $CurrentSettings; break }
            '^showonly:'   { $CurrentSettings -replace 'home;?'; break }
            '^hide:'       { $CurrentSettings -replace '(hide:)', '${1}home;'; break }
            Default        { 'hide:home' }
        }

        # gpo\ computer config > administrative tpl > control panel
        #   settings page visibility
        # not configured: delete (default) | on: 'showonly:personalization;windowsupdate', 'hide:home'
        $SettingsPageVisibilityGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'SettingsPageVisibility'
                    Value = $PageVisibility
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Home Setting Page Visibility (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $SettingsPageVisibilityGpo
    }
}
