#=================================================================================================================
#                           Network & Internet > Ethernet/Wi-Fi > DNS Server Assignment
#=================================================================================================================

class DnsProvidersNames : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return $Script:DnsProvidersList.Keys
    }
}

<#
.SYNTAX
    Set-DnsServer
        -ResetServerAddresses
        [<CommonParameters>]

    Set-DnsServer
        -Provider 'Adguard'
        -Server {Default | Unfiltered | Family}
        [-FallbackToPlaintext]
        [<CommonParameters>]

    Set-DnsServer
        -Provider 'Cloudflare'
        -Server {Default | Security | Family}
        [-FallbackToPlaintext]
        [<CommonParameters>]

    Set-DnsServer
        -Provider 'Mullvad'
        -Server {Default | Adblock | Base | Extended | Family | All}
        [-FallbackToPlaintext]
        [<CommonParameters>]

    Set-DnsServer
        -Provider 'Quad9'
        -Server {Default | Unfiltered}
        [-FallbackToPlaintext]
        [<CommonParameters>]
#>

function Set-DnsServer
{
    <#
    .DESCRIPTION
        Mullvad does not support unencrypted DNS.
        i.e. -FallbackToPlaintext can be set but will not work.

        Dynamic parameters:
            -Server: available values depend on the selected Provider.
                Adguard    : -Server {Default | Unfiltered | Family}
                Cloudflare : -Server {Default | Security | Family}
                Mullvad    : -Server {Default | Adblock | Base | Extended | Family | All}
                Quad9      : -Server {Default | Unfiltered}

    .EXAMPLE
        PS> Set-DnsServer -Provider 'Cloudflare' -Server 'Default'

    .EXAMPLE
        PS> Set-DnsServer -ResetServerAddresses
    #>

    [CmdletBinding(DefaultParameterSetName = 'Setting')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Setting')]
        [ValidateSet([DnsProvidersNames])]
        [string] $Provider,

        [Parameter(ParameterSetName = 'Setting')]
        [switch] $FallbackToPlaintext,

        [Parameter(Mandatory, ParameterSetName = 'Reset')]
        [switch] $ResetServerAddresses
    )

    dynamicparam
    {
        if ($Provider)
        {
            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()

            $DynamicParamProperties = @{
                Dictionary = $ParamDictionary
                Name       = 'Server'
                Type       = [string]
                Attribute  = @{
                    Parameter = @{ Mandatory = $true; ParameterSetName = 'Setting' }
                    ValidateSet = $DnsProvidersList.$Provider.Keys
                }
            }
            Add-DynamicParameter @DynamicParamProperties

            $ParamDictionary
        }
    }

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Setting')
        {
            $RegPath = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters'
            $RegDohIPv4 = 'DohInterfaceSettings\Doh'
            $RegDohIPv6 = 'DohInterfaceSettings\Doh6'

            $Server = $PSBoundParameters.Server
            $DohTpl = $DnsProvidersList.$Provider.$Server.Doh
            $IPv4 = $DnsProvidersList.$Provider.$Server.IPv4
            $IPv6 = $DnsProvidersList.$Provider.$Server.IPv6
        }

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
            }
            else
            {
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
        }

        Clear-DnsClientCache
        Register-DnsClient
    }
}
