#=================================================================================================================
#                                    Bluetooth & Devices > Devices - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DevicesSetting
        [-DownloadOverMeteredConnections {Disabled | Enabled}]
        [-DefaultPrinterSystemManaged {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-DevicesSetting
{
    <#
    .EXAMPLE
        PS> Set-DevicesSetting -DownloadOverMeteredConnections 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $DownloadOverMeteredConnections,

        [state] $DefaultPrinterSystemManaged
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'DownloadOverMeteredConnections' { Set-DevicesDownloadOverMeteredConnections -State $DownloadOverMeteredConnections }
            'DefaultPrinterSystemManaged'    { Set-DefaultPrinterSystemManaged -State $DefaultPrinterSystemManaged }
        }
    }
}
