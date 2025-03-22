#=================================================================================================================
#                                            Network Adapter Protocol
#=================================================================================================================

# settings > network & internet > advanced network settings > Ethernet and/or Wi-FI: more adapter options > edit

class NetAdapterProtocol
{
    [string] $DisplayName
    [string] $ComponentID
    [bool] $Enabled
    [bool] $Default
    [string] $Comment
}

<#
.SYNTAX
    Set-NetAdapterProtocolState
        [-InputObject] <NetAdapterProtocol>
        [-RestoreDefault]
        [<CommonParameters>]
#>

function Set-NetAdapterProtocolState
{
    <#
    .EXAMPLE
        PS> $Protocol = '[
              {
                "DisplayName": "File and Printer Sharing for Microsoft Networks",
                "ComponentID": "ms_server",
                "Enabled"    : false,
                "Default"    : true,
                "Comment"    : "SMB server"
              }
            ]' | ConvertFrom-Json
        PS> $Protocol | Set-NetAdapterProtocolState -RestoreDefault
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [NetAdapterProtocol] $InputObject,

        [switch] $RestoreDefault
    )

    begin
    {
        $PhysicalNetAdapter = Get-NetAdapter -Physical
    }

    process
    {
        $IsEnabled = $RestoreDefault ? $InputObject.Default : $InputObject.Enabled
        $CurrentNetAdapterBinding = $PhysicalNetAdapter |
            Get-NetAdapterBinding -ComponentID $InputObject.ComponentID -ErrorAction 'SilentlyContinue'

        if ($CurrentNetAdapterBinding)
        {
            if ($IsEnabled -eq $CurrentNetAdapterBinding.Enabled)
            {
                Write-Verbose -Message "Network protocol '$($InputObject.DisplayName) ($($InputObject.ComponentID))' is already set to '$IsEnabled'"
            }
            else
            {
                Write-Verbose -Message "Setting network protocol '$($InputObject.DisplayName) ($($InputObject.ComponentID))' to '$IsEnabled' ..."
                $PhysicalNetAdapter | Set-NetAdapterBinding -ComponentID $InputObject.ComponentID -Enabled $IsEnabled
            }
        }
        else
        {
            Write-Verbose -Message "Network protocol '$($InputObject.DisplayName) ($($InputObject.ComponentID))' not found"
        }
    }
}
