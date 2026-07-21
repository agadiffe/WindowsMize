#=================================================================================================================
#                               System > Optional Features - Set Windows Capability
#=================================================================================================================

# For mysterious reasons, adding a Windows Capability takes a (really) long time ... (even with the GUI).
# I recommend not adding any as part of this script.

<#
.SYNTAX
    Set-WindowsCapability
        [-Name] <string>
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WindowsCapability
{
    <#
    .EXAMPLE
        PS> Set-WindowsCapability -Name 'Print.Fax.Scan' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # "Get-WindowsCapability -Online" fails on PowerShell from MSIX installation: Class not registered.
        # https://github.com/PowerShell/PowerShell/issues/13866
        # "Import-Module -Name 'xxx' -UseWindowsPowerShell" import the 1.0 version ...

        $WinCapability = powershell.exe -args $Name -NoProfile -Command {
            Get-WindowsCapability -Online -Name $args[0] -Verbose:$false
        }

        if (-not $WinCapability.Name)
        {
            Write-Verbose -Message "Windows Capability '$Name' not found"
            return
        }

        $StateInternalName = $State -eq 'Enabled' ? 'Installed' : 'NotPresent'
        if ($WinCapability.State.Value -eq $StateInternalName)
        {
            Write-Verbose -Message "$Name is already '$StateInternalName'"
        }
        else
        {
            switch ($State)
            {
                'Enabled'
                {
                    Write-Verbose -Message "Adding $Name ..."
                    powershell.exe -Args $WinCapability.Name -NoProfile -Command {
                        Add-WindowsCapability -Name $Args[0] -Online -Verbose:$false | Out-Null
                    }
                }
                'Disabled'
                {
                    Write-Verbose -Message "Removing $Name ..."
                    powershell.exe -Args $WinCapability.Name -NoProfile -Command {
                        Remove-WindowsCapability -Name $Args[0] -Online -Verbose:$false | Out-Null
                    }
                }
            }
        }
    }
}
