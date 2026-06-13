#=================================================================================================================
#                                          Home Setting Page Visibility
#=================================================================================================================

# The identifier for any given settings page is the published URI for that page, minus the "ms-settings:" protocol part.
# https://learn.microsoft.com/en-us/windows/apps/develop/launch/launch-settings#ms-settings-uri-scheme-reference

<#
.SYNTAX
    Set-HomeSettingPageVisibility
        [-GPO] {Hide | Show}
        [<CommonParameters>]
#>

function Set-HomeSettingPageVisibility
{
    <#
    .DESCRIPTION
        Control only the visibility of the Home page. Other GPO PageID values are not modified.

    .EXAMPLE
        PS> Set-HomeSettingPageVisibility -GPO 'Hide'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Hide', 'Show')]
        [string] $GPO
    )

    process
    {
        $GpoData = Get-SettingsPageVisibilityData
        $Mode = $GpoData['Mode'] -eq 'ShowOnly' ? 'ShowOnly' : 'Hide'
        $Action = $Mode.Substring(0, 4) -eq $GPO ? 'Add' : 'Remove'

        Set-SettingsPageVisibility -PageId 'home' -Mode $Mode -Action $Action
    }
}


<#
.SYNTAX
    Get-SettingsPageVisibilityData [<CommonParameters>]
#>

function Get-SettingsPageVisibilityData
{
    <#
    .EXAMPLE
        PS> Get-SettingsPageVisibilityData
    #>

    [CmdletBinding()]
    param ()

    process
    {
        $RegPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        $CurrentSettings = (Get-ItemProperty -Path $RegPath -ErrorAction 'SilentlyContinue').SettingsPageVisibility

        $Matched = $CurrentSettings -match '(hide|showonly):(.*)'
        $Data = @{
            Mode  = $Matched ? $Matches[1] : $null
            Value = $Matched ? $Matches[2] : $null
        }
        $Data
    }
}


<#
.SYNTAX
    Set-SettingsPageVisibility
        [-PageId] <string[]>
        [-Mode] {Hide | ShowOnly}
        [-Action] {Remove | Add | Override}
        [<CommonParameters>]

    Set-SettingsPageVisibility
        -Reset
        [<CommonParameters>]
#>

function Set-SettingsPageVisibility
{
    <#
    .EXAMPLE
        PS> Set-SettingsPageVisibility -PageId 'home', 'bluetooth' -Mode 'Hide' -Action 'Add'
        current: hide:about
        new:     hide:about;home;bluetooth

    .EXAMPLE
        PS> Set-SettingsPageVisibility -PageId 'home', 'bluetooth' -Mode 'Hide' -Action 'Override'
        current: hide:about
        new:     hide:home;bluetooth

    .EXAMPLE
        PS> Set-SettingsPageVisibility -Reset
        current: hide:about
        new:     GPO is NotConfigured
    #>

    [CmdletBinding(DefaultParameterSetName = 'Setting')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Setting')]
        [string[]] $PageId,

        [Parameter(Mandatory, ParameterSetName = 'Setting')]
        [ValidateSet('Hide', 'ShowOnly')]
        [string] $Mode,

        [Parameter(Mandatory, ParameterSetName = 'Setting')]
        [ValidateSet('Remove', 'Add', 'Override')]
        [string] $Action,

        [Parameter(Mandatory, ParameterSetName = 'Reset')]
        [switch] $Reset
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Reset' -and -not $Reset)
        {
            return
        }

        if (-not $Reset)
        {
            $GpoData = Get-SettingsPageVisibilityData
            $CurrentMode = $GpoData['Mode']
            $CurrentValue = $GpoData['Value']
    
            $Value = -not $CurrentValue -or $CurrentMode -ne $Mode -or $Action -eq 'Override' ?
                [System.Collections.ArrayList]::new() :
                [System.Collections.ArrayList]($CurrentValue -split ';')

            foreach ($Id in $PageId)
            {
                switch ($Action)
                {
                    'Remove'   { $Value.Remove($Id) }
                    'Add'      { if (-not $Value.Contains($Id)) { $Value.Add($Id) | Out-Null } }
                    'Override' { $Value.Add($Id) | Out-Null }
                }
            }

            for ($i = $Value.Count - 1; $i -ge 0; $i--)
            {
                if ([string]::IsNullOrWhiteSpace($Value[$i]))
                {
                    $Value.RemoveAt($i)
                }
            }

            $RegValue = "${Mode}:$($Value -join ';')"
        }

        $IsNotConfigured = $Reset -or -not $Value.Count

        # gpo\ computer config > administrative tpl > control panel
        #   settings page visibility
        # not configured: delete (default) | on: 'showonly:personalization;windowsupdate', 'hide:home'
        $SettingsPageVisibilityGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = 'SettingsPageVisibility'
                    Value = $RegValue
                    Type  = 'String'
                }
            )
        }

        $SettingMsg = $IsNotConfigured ? 'NotConfigured' : $RegValue
        Write-Verbose -Message "Setting 'Settings Page Visibility (GPO)' to '$SettingMsg' ..."
        Set-RegistryEntry -InputObject $SettingsPageVisibilityGpo
    }
}
