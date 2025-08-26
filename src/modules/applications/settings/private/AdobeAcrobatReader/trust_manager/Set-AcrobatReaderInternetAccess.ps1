#=================================================================================================================
#      Acrobat Reader - Preferences > Trust Manager > Internet Access From PDF Files > Access All Web Sites
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderInternetAccess
        [[-State] {BlockAllWebSites | AllowAllWebSites | Custom}]
        [-GPO {BlockAllWebSites | AllowAllWebSites | Custom | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderInternetAccess
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderInternetAccess -State 'Custom' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [AdobeInternetAccessMode] $State,

        [AdobeInternetAccessModeGpo] $GPO
    )

    process
    {
        $InternetAccessMsg = 'Acrobat Reader - Internet Access From PDF Files: Access All Web Sites'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 2 | off: 1 | custom: 0 (default)
                $AcrobatReaderInternetAccess = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager\cDefaultLaunchURLPerms'
                    Entries = @(
                        @{
                            Name  = 'iURLPerms'
                            Value = [int]$State
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$InternetAccessMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderInternetAccess
            }
            'GPO'
            {
                # gpo\ TrustManager > Internet Access
                #   specifies whether to allow or block all websites or use a custom setting
                # not configured: delete (default) | on: 2 | off: 1 | custom: 0
                $AcrobatReaderInternetAccessGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cDefaultLaunchURLPerms'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'iURLPerms'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$InternetAccessMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderInternetAccessGpo
            }
        }
    }
}
