#=================================================================================================================
#       Defender > App & Browser Control > Reputation-Based Protection > Potentially Unwanted App Blocking
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderUnwantedAppBlocking
        [[-State] {Disabled | Enabled | AuditMode}]
        [-GPO {Disabled | Enabled | AuditMode | NotConfigured}]
        [<CommonParameters>]
#>

function Set-DefenderUnwantedAppBlocking
{
    <#
    .EXAMPLE
        PS> Set-DefenderUnwantedAppBlocking -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [PUAProtectionMode] $State,

        [GpoPUAProtectionMode] $GPO
    )

    process
    {
        $DefenderUnwantedAppBlockingMsg = 'Defender - Potentially Unwanted App Blocking'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # Disabled | Enabled (default) | AuditMode
                Write-Verbose -Message "Setting '$DefenderUnwantedAppBlockingMsg' to '$State' ..."
                Set-MpPreference -PUAProtection $State
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus
                #   configure detection for potentially unwanted applications
                # not configured: delete (default) | on: 1 | off: 0 | AuditMode: 2
                $DefenderUnwantedAppBlockingGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows Defender'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'PUAProtection'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$DefenderUnwantedAppBlockingMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $DefenderUnwantedAppBlockingGpo
            }
        }
    }
}
