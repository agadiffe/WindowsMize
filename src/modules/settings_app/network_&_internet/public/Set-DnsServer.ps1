#=================================================================================================================
#                           Network & Internet > Ethernet/Wi-Fi > DNS Server Assignment
#=================================================================================================================

<#
.SYNTAX
    Set-DnsServer -ResetServerAddresses [<CommonParameters>]

    Set-DnsServer -Adguard {Default | Unfiltered | Family} [-FallbackToPlaintext] [<CommonParameters>]

    Set-DnsServer -Cloudflare {Default | Security | Family} [-FallbackToPlaintext] [<CommonParameters>]

    Set-DnsServer -Dns0 {Default | Zero | Kids} [-FallbackToPlaintext] [<CommonParameters>]

    Set-DnsServer -Mullvad {Default | Adblock | Base | Extended | Family | All} [<CommonParameters>]

    Set-DnsServer -Quad9 {Default | Unfiltered} [-FallbackToPlaintext] [<CommonParameters>]
#>

function Set-DnsServer
{
    <#
    .EXAMPLE
        PS> Set-DnsServer -Cloudflare 'Default'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Reset')]
        [switch] $ResetServerAddresses,

        [Parameter(ParameterSetName = 'Adguard')]
        [Parameter(ParameterSetName = 'Cloudflare')]
        [Parameter(ParameterSetName = 'Dns0')]
        [Parameter(ParameterSetName = 'Quad9')]
        [switch] $FallbackToPlaintext,

        [Parameter(Mandatory, ParameterSetName = 'Adguard')]
        [ValidateSet('Default', 'Unfiltered', 'Family')]
        [string] $Adguard,

        [Parameter(Mandatory, ParameterSetName = 'Cloudflare')]
        [ValidateSet('Default', 'Security', 'Family')]
        [string] $Cloudflare,

        [Parameter(Mandatory, ParameterSetName = 'Dns0')]
        [ValidateSet('Default', 'Zero', 'Kids')]
        [string] $Dns0,

        [Parameter(Mandatory, ParameterSetName = 'Mullvad')]
        [ValidateSet('Default', 'Adblock', 'Base', 'Extended', 'Family', 'All')]
        [string] $Mullvad,

        [Parameter(Mandatory, ParameterSetName = 'Quad9')]
        [ValidateSet('Default', 'Unfiltered')]
        [string] $Quad9
    )

    process
    {
        $Provider = $PSCmdlet.ParameterSetName
        $Server = switch ($Provider)
        {
            'Adguard'    { $Adguard }
            'Cloudflare' { $Cloudflare }
            'Dns0'       { $Dns0 }
            'Mullvad'    { $Mullvad }
            'Quad9'      { $Quad9 }
        }

        $RegPath = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters'
        $RegDohIPv4 = 'DohInterfaceSettings\Doh'
        $RegDohIPv6 = 'DohInterfaceSettings\Doh6'

        $DohTpl = $DnsProvidersList.$Provider.$Server.Doh
        $IPv4 = $DnsProvidersList.$Provider.$Server.IPv4
        $IPv6 = $DnsProvidersList.$Provider.$Server.IPv6

        $NetAdapters = Get-NetAdapter -Physical | Where-Object -Property 'Status' -NE -Value 'Disabled'

        foreach ($NetAdapter in $NetAdapters)
        {
            if ($PSCmdlet.ParameterSetName -eq 'Reset')
            {
                if ($ResetServerAddresses)
                {
                    Write-Verbose -Message "Resetting '$($NetAdapter.Name) DNS Server' ..."
                    Set-DnsClientServerAddress -InterfaceAlias $NetAdapter.InterfaceAlias -ResetServerAddresses
                }
                Continue
            }

            Write-Verbose -Message "Setting '$($NetAdapter.Name) DNS Server' To '$Provider : $Server' ..."

            Set-DnsClientServerAddress -InterfaceAlias $NetAdapter.InterfaceAlias -ServerAddresses $IPv4, $IPv6

            $InterfaceGuid = $NetAdapter.InterfaceGuid
            $RegIPs= @(
                $IPv4.ForEach({ "$RegPath\$InterfaceGuid\$RegDohIPv4\$_" })
                $IPv6.ForEach({ "$RegPath\$InterfaceGuid\$RegDohIPv6\$_" })
            )
            foreach ($RegIP in $RegIPs)
            {
                if (-not (Test-Path -Path $RegIP))
                {
                    New-Item -Path $RegIP -Force | Out-Null
                }
                # To use automatic template, the DoH template must be registered in the system.
                # See Get-DnsClientDohServerAddress and Add-DnsClientDohServerAddress.
                # template\ automatic: 1 (with fallback: 5) | manual: 2 (with fallback: 6)
                $DohFlags = 2
                if ($FallbackToPlaintext)
                {
                    $DohFlags += 4
                }
                Set-ItemProperty -Path $RegIP -Name 'DohFlags' -Value $DohFlags -Type 'QWord' | Out-Null
                Set-ItemProperty -Path $RegIP -Name 'DohTemplate' -Value $DohTpl -Type 'String' | Out-Null
            }
        }

        Clear-DnsClientCache
        Register-DnsClient
    }
}
