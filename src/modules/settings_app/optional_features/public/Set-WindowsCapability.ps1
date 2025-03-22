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
        [ValidateSet('Disabled', 'Enabled')]
        [string] $State
    )

    process
    {
        $WinCapability = Get-WindowsCapability -Online -Name $Name -Verbose:$false
        if (-not $WinCapability.Name)
        {
            Write-Verbose -Message "Windows Capability '$Name' not found"
            return
        }

        $StateInternalName = $State -eq 'Enabled' ? 'Installed' : 'NotPresent'
        if ($WinCapability.State -eq $StateInternalName)
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
                    $WinCapability | Add-WindowsCapability -Online -Verbose:$false | Out-Null
                }
                'Disabled'
                {
                    Write-Verbose -Message "Removing $Name ..."
                    $WinCapability | Remove-WindowsCapability -Online -Verbose:$false | Out-Null
                }
            }
        }
    }
}
