#=================================================================================================================
#                                         Telemetry - Diagnostic Tracing
#=================================================================================================================

# Function not used.

# owner: TrustedInstaller | full control: TrustedInstaller
# Requested registry access is not allowed.

# Since this is the only protected key whose default value is undesirable,
# I guess it's okay to change it manually.

<#
  Open 'regedit'.
  Right-click on the key and select 'Permissions'.
  On the Permissions window, select 'Advanced'.
  Click on 'Change' to change the owner.
  Type 'Administrators' in the 'Enter the object name and select' field and press OK.
  Double-click on 'Administrators' from the list of Permission Entries.
  Select the checkbox besides 'Full Control' under Basic permissions and press OK.

  Modify the registry entry 'DisableDiagnosticTracing' to '1'.

  Restore permissions to 'TrustedInstaller':
  Remove 'Full Control' from 'Administrators'.
  Change the owner to 'TrustedInstaller' (use 'NT SERVICE\TrustedInstaller' for the object name).
#>

<#
.SYNTAX
    Set-DiagnosticTracing
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DiagnosticTracing
{
    <#
    .EXAMPLE
        PS> Set-DiagnosticTracing -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $DiagnosticTracing = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Diagnostics\Performance'
            Entries = @(
                @{
                    Name  = 'DisableDiagnosticTracing'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Diagnostic Tracing' to '$State' ..."
        Set-RegistryEntry -InputObject $DiagnosticTracing
    }
}
