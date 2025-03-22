#=================================================================================================================
#                           System Properties - System Protection > Protection Settings
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# Use system protection to undo unwanted system changes.
# System Restore are not always reliable. You should use a proper system backup solution.

# You will not be able to Turn on system protection for other drives if system protection
# is not turned on for the Windows 'System' drive.

# If you disable System Restore, a Windows update may enable it again ?
# You can disable the related services or use Group Policy to disable the feature completely.

# default: Enabled for system drive (e.g. 'C:\')

<#
.SYNTAX
    Set-SystemRestore
        [-Drive] <string[]>
        [-State] {Disabled | Enabled}
        [<CommonParameters>]

    Set-SystemRestore
        [-AllDrivesDisabled]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-SystemRestore
{
    <#
    .EXAMPLE
        PS> Set-SystemRestore -Drive $env:SystemDrive -State 'Disabled'

    .EXAMPLE
        PS> Set-SystemRestore -AllDrivesDisabled -GPO 'NotConfigured'
    #>

    [CmdletBinding(DefaultParameterSetName = 'SelectDrive')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'SelectDrive')]
        [ValidatePattern(
            '^[A-Za-z]:\\?$',
            ErrorMessage = 'Drive format must be a letter followed by a colon, ' +
                           'optionally with a backslash (e.g. ''C:'' or ''C:\'').')]
        [ValidateScript(
            { Test-Path -Path $_ },
            ErrorMessage = 'The specified drive does not exist or is not accessible.')]
        [string[]] $Drive,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'SelectDrive')]
        [state] $State,

        [Parameter(ParameterSetName = 'AllDrives')]
        [switch] $AllDrivesDisabled,

        [Parameter(ParameterSetName = 'AllDrives')]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'SelectDrive'
            {
                Write-Verbose -Message "Setting 'System Restore' For Drive '$Drive' to '$State' ..."

                switch ($State)
                {
                    'Enabled'  { Enable-ComputerRestore -Drive $Drive }
                    'Disabled' { Disable-ComputerRestore -Drive $Drive }
                }
            }
            'AllDrives'
            {
                if ($AllDrivesDisabled)
                {
                    # off: delete 0
                    $SystemRestore = @(
                        @{
                            Hive    = 'HKEY_LOCAL_MACHINE'
                            Path    = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients'
                            Entries = @(
                                @{
                                    RemoveEntry = $true
                                    Name  = '{09f7edc5-294e-4180-af6a-fb0e6a0e9513}'
                                    Value = ''
                                    Type  = 'DWord'
                                }
                            )
                        }
                        @{
                            Hive    = 'HKEY_LOCAL_MACHINE'
                            Path    = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
                            Entries = @(
                                @{
                                    Name  = 'RPSessionInterval'
                                    Value = '0'
                                    Type  = 'DWord'
                                }
                            )
                        }
                    )

                    Write-Verbose -Message 'Setting ''System Restore For All Drives'' to ''Disabled'' ...'
                    $SystemRestore | Set-RegistryEntry
                }

                if ($PSBoundParameters.ContainsKey('GPO'))
                {
                    $IsNotConfigured = $GPO -eq 'NotConfigured'

                    # gpo\ computer config > administrative tpl > system > system restore
                    #   turn off configuration
                    #   turn off system restore
                    # not configured: delete (default) | on: 1
                    $SystemRestoreGpo = @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = 'SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore'
                        Entries = @(
                            @{
                                RemoveEntry = $IsNotConfigured
                                Name  = 'DisableConfig'
                                Value = '1'
                                Type  = 'DWord'
                            }
                            @{
                                RemoveEntry = $IsNotConfigured
                                Name  = 'DisableSR'
                                Value = '1'
                                Type  = 'DWord'
                            }
                        )
                    }

                    Write-Verbose -Message "Setting 'System Restore For All Drives (GPO)' to '$GPO' ..."
                    Set-RegistryEntry -InputObject $SystemRestoreGpo
                }
            }
        }
    }
}
