#=================================================================================================================
#                   Defender > Settings > Notifications > Get Account Protection Notifications
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderAccountNotifs
        [-AllNotifs] {Disabled | Enabled}
        [<CommonParameters>]

    Set-DefenderAccountNotifs
        [-WindowsHelloProblems {Disabled | Enabled}]
        [-DynamicLockProblems {Disabled | Enabled}]
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
        [state] $WindowsHelloProblems,

        [Parameter(ParameterSetName = 'Specific')]
        [state] $DynamicLockProblems
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'All')
        {
            $PSBoundParameters.WindowsHelloProblems = $AllNotifs
            $PSBoundParameters.DynamicLockProblems = $AllNotifs
        }

        switch ($PSBoundParameters.Keys)
        {
            'WindowsHelloProblems' { Set-DefenderNotifsWindowsHello -State $PSBoundParameters.WindowsHelloProblems }
            'DynamicLockProblems'  { Set-DefenderNotifsDynamicLock -State $PSBoundParameters.DynamicLockProblems }
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
