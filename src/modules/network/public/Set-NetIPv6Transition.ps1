#=================================================================================================================
#                                 Network Protocol - IPv6 transition technologies
#=================================================================================================================

# IPv6 transition technologies, which tunnel packets through other protocols, do not provide visibility.
# It means that these mechanisms can obscure network traffic.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-NetIPv6Transition
        [-Name] {6to4 | IP-HTTPS | ISATAP | Teredo}
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NetIPv6Transition
{
    <#
    .EXAMPLE
        PS> Set-NetIPv6Transition -Name '6to4', 'Teredo' -State 'Disabled' -GPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateSet('6to4', 'IP-HTTPS', 'ISATAP', 'Teredo')]
        [string[]] $Name,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName)]
        [state] $State,

        [Parameter(ValueFromPipelineByPropertyName)]
        [GpoState] $GPO
    )

    process
    {
        if (-not ($PSBoundParameters.Keys.Count - 1))
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            Write-Error -Message 'Specify at least the ''State'' or ''GPO'' parameter.'
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                switch ($Name)
                {
                    '6to4'     { Set-NetProtocol6to4 -State $State }
                    'IP-HTTPS' { Set-NetProtocolIPHttps -State $State }
                    'ISATAP'   { Set-NetProtocolIsatap -State $State }
                    'Teredo'   { Set-NetProtocolTeredo -State $State }
                }
            }
            'GPO'
            {
                switch ($Name)
                {
                    '6to4'     { Set-NetProtocol6to4 -GPO $GPO }
                    'IP-HTTPS' { Set-NetProtocolIPHttps -GPO $GPO }
                    'ISATAP'   { Set-NetProtocolIsatap -GPO $GPO }
                    'Teredo'   { Set-NetProtocolTeredo -GPO $GPO }
                }
            }
        }
    }
}
