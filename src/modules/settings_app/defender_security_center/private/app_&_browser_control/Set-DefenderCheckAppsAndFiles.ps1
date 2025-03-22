#=================================================================================================================
#              Defender > App & Browser Control > Reputation-Based Protection > Check Apps And Files
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderCheckAppsAndFiles
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Warn | Block | NotConfigured}]
        [<CommonParameters>]
#>

function Set-DefenderCheckAppsAndFiles
{
    <#
    .EXAMPLE
        PS> Set-DefenderCheckAppsAndFiles -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoCheckAppsAndFilesMode] $GPO
    )

    process
    {
        $DefenderCheckAppsAndFilesMsg = 'Defender - Check Apps And Files'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: Warn (default) | off: Off
                $DefenderCheckAppsAndFiles = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer'
                    Entries = @(
                        @{
                            Name  = 'SmartScreenEnabled'
                            Value = $State -eq 'Enabled' ? 'Warn' : 'Off'
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderCheckAppsAndFilesMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $DefenderCheckAppsAndFiles
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                # gpo\ computer config > administrative tpl > windows components > file explorer
                #      computer config > administrative tpl > windows components > windows defender smartscreen > explorer
                #   configure Windows Defender SmartScreen
                # not configured: delete (default) | on: 1 Warn/Block | off: 0 delete
                $DefenderCheckAppsAndFilesGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\System'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'EnableSmartScreen'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured -or $GPO -eq 'Disabled'
                            Name  = 'ShellSmartScreenLevel'
                            Value = $GPO -eq 'Warn' ? 'Warn' : 'Block'
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderCheckAppsAndFilesMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $DefenderCheckAppsAndFilesGpo
            }
        }
    }
}
