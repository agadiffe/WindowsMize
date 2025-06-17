#=================================================================================================================
#                                             Microsoft Store Setting
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsTerminalSetting
        [-DefaultProfile {WindowsPowerShell | CommandPrompt | PowerShellCore}]
        [-DefaultCommandTerminalApp {LetWindowsDecide | WindowsConsoleHost | WindowsTerminal}]
        [-DefaultColorScheme {CGA | Campbell | Campbell Powershell | Dark+ | IBM 5153 | One Half Dark |
                              One Half Light | Ottosson | Solarized Dark | Solarized Light | Tango Dark |
                              Tango Light | Vintage}]
        [-DefaultHistorySize <int>]
        [-RunAtStartup {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-WindowsTerminalSetting
{
    <#
    .EXAMPLE
        PS> Set-WindowsTerminalSetting -DefaultColorScheme 'One Half Dark' -DefaultHistorySize 32767
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [ValidateSet('WindowsPowerShell', 'CommandPrompt', 'PowerShellCore')]
        [string] $DefaultProfile,

        [ValidateSet('LetWindowsDecide', 'WindowsConsoleHost', 'WindowsTerminal')]
        [string] $DefaultCommandTerminalApp,

        [ValidateSet(
            'CGA',
            'Campbell',
            'Campbell Powershell',
            'Dark+',
            'IBM 5153',
            'One Half Dark',
            'One Half Light',
            'Ottosson',
            'Solarized Dark',
            'Solarized Light',
            'Tango Dark',
            'Tango Light',
            'Vintage')]
        [string] $DefaultColorScheme,

        [ValidateRange('NonNegative')]
        [int] $DefaultHistorySize,

        [state] $RunAtStartup
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $TerminalAppxPath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe"
        $TerminalSettingsFilePath = "$TerminalAppxPath\LocalState\settings.json"

        if (-not (Test-Path -Path $TerminalSettingsFilePath))
        {
            Write-Verbose -Message 'Windows Terminal is not installed'
        }
        else
        {
            $TerminalSettingsContent = Get-Content -Raw -Path $TerminalSettingsFilePath
            $TerminalSettings = $TerminalSettingsContent | ConvertFrom-Json -AsHashtable

            $TerminalMsg = 'Windows Terminal'

            switch ($PSBoundParameters.Keys)
            {
                'DefaultProfile'
                {
                    Write-Verbose -Message "Setting '$TerminalMsg - DefaultProfile' to '$DefaultProfile' ..."

                    $ProfileName = switch ($DefaultProfile)
                    {
                        'WindowsPowerShell' { 'Windows PowerShell' }
                        'CommandPrompt'     { 'Command Prompt' }
                        'PowerShellCore'    { 'PowerShell' }
                    }

                    # default: Windows PowerShell
                    $ProfileData = $TerminalSettings.profiles.list | Where-Object -Property 'name' -EQ -Value $ProfileName
                    if ($ProfileData)
                    {
                        $TerminalSettings.defaultProfile = $ProfileData.guid
                    }
                }
                'DefaultCommandTerminalApp'
                {
                    Write-Verbose -Message "Setting '$TerminalMsg - DefaultCommandTerminalApp' to '$DefaultCommandTerminalApp' ..."

                    $DelegationConsoleGuid, $DelegationTerminalGuid = switch ($DefaultCommandTerminalApp)
                    {
                        'LetWindowsDecide'   { '{00000000-0000-0000-0000-000000000000}', '{00000000-0000-0000-0000-000000000000}' }
                        'WindowsConsoleHost' { '{b23d10c0-e52e-411e-9d5b-c09fdf709c7d}', '{b23d10c0-e52e-411e-9d5b-c09fdf709c7d}' }
                        'WindowsTerminal'    { '{2eaca947-7f5f-4cfa-ba87-8f7fbeefbe69}', '{e12cff52-a866-4c77-9a90-f570a7aa2c6b}' }
                    }

                    # Let Windows decide:   {00000000-0000-0000-0000-000000000000}
                    # Windows Console Host: {b23d10c0-e52e-411e-9d5b-c09fdf709c7d} (default)
                    # Windows Terminal:     {2eaca947-7f5f-4cfa-ba87-8f7fbeefbe69} {e12cff52-a866-4c77-9a90-f570a7aa2c6b}
                    $TerminalDefaultApp = @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Console\%%Startup'
                        Entries = @(
                            @{
                                Name  = 'DelegationConsole'
                                Value = $DelegationConsoleGuid
                                Type  = 'String'
                            }
                            @{
                                Name  = 'DelegationTerminal'
                                Value = $DelegationTerminalGuid
                                Type  = 'String'
                            }
                        )
                    }
                    Set-RegistryEntry -InputObject $TerminalDefaultApp -Verbose:$false
                }
                'DefaultColorScheme'
                {
                    Write-Verbose -Message "Setting '$TerminalMsg - DefaultColorScheme' to '$DefaultColorScheme' ..."

                    # default: Campbell
                    $TerminalSettings.profiles.defaults.colorScheme = $DefaultColorScheme
                }
                'DefaultHistorySize'
                {
                    Write-Verbose -Message "Setting '$TerminalMsg - DefaultHistorySize' to '$DefaultHistorySize' ..."

                    # default: 9001 | max: 32767 (even if higher value provided)
                    $TerminalSettings.profiles.defaults.historySize = $DefaultHistorySize
                }
                'RunAtStartup'
                {
                    Write-Verbose -Message "Setting '$TerminalMsg - RunAtStartup' to '$RunAtStartup' ..."

                    # default: disabled
                    $TerminalSettings.startOnUserLogin = $RunAtStartup -eq 'Enabled'
                }
            }

            $TerminalSettings | ConvertTo-Json -Depth 100 | Out-File -FilePath $TerminalSettingsFilePath
        }
    }
}
