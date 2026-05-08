#=================================================================================================================
#                          System > Troubleshoot > Recommended Troubleshooter Preference
#=================================================================================================================

<#
.SYNTAX
    Set-TroubleshooterPreference
        [-RunMode] {Disabled | AskBeforeRunning | AutoRunAndNotify | AutoRunSilently}
        [<CommonParameters>]
#>

function Set-TroubleshooterPreference
{
    <#
    .EXAMPLE
        PS> Set-TroubleshooterPreference -RunMode 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Disabled', 'AskBeforeRunning', 'AutoRunAndNotify', 'AutoRunSilently' )]
        [string] $RunMode
    )

    process
    {
        $SettingValue = switch ($RunMode)
        {
            'Disabled'         { '1' }
            'AskBeforeRunning' { '2' }
            'AutoRunAndNotify' { '3' }
            'AutoRunSilently'  { '4' }
        }

        # don't run any: 1 | ask me before running: 2 (default)
        # run automatically, then notify me: 3 | run automatically, don't notify me: 4
        $TroubleshootPreference = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\WindowsMitigation'
            Entries = @(
                @{
                    Name  = 'UserPreference'
                    Value = $SettingValue
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Troubleshoot - Recommended Troubleshooter Preference' to '$RunMode' ..."
        Set-RegistryEntry -InputObject $TroubleshootPreference
    }
}
