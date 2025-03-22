#=================================================================================================================
#                   Defender > Settings > Notifications > Get Account Protection Notifications
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderAccountNotifs
        [-AllNotifs] {Disabled | Enabled}
        [<CommonParameters>]

    Set-DefenderAccountNotifs
        [-WindowsHello {Disabled | Enabled}]
        [-DynamicLock {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-DefenderAccountNotifs
{
    <#
    .EXAMPLE
        PS> Set-DefenderAccountNotifs -AllNotifs 'Disabled'
    #>

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'All')]
        [state] $AllNotifs,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $WindowsHello,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $DynamicLock
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'All')
        {
            $PSBoundParameters.WindowsHello = $AllNotifs
            $PSBoundParameters.DynamicLock = $AllNotifs
        }

        switch ($PSBoundParameters.Keys)
        {
            'WindowsHello' { Set-DefenderNotifsWindowsHello -State $PSBoundParameters.WindowsHello }
            'DynamicLock'  { Set-DefenderNotifsDynamicLock -State $PSBoundParameters.DynamicLock }
        }

        # on: 0 (default) | off: 1
        $DefenderAccountNotifs = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows Defender Security Center\Account protection'
            Entries = @(
                @{
                    Name  = 'DisableNotifications'
                    Value = (Test-DefenderNotifsEnabled -Name 'Account') ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }
        Set-RegistryEntry -InputObject $DefenderAccountNotifs
    }
}
