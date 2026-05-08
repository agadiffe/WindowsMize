#=================================================================================================================
#   Acrobat Reader - Preferences > Trust Manager > Internet Access From PDF Files > Behavior If Not In The List
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderInternetAccessUnknownUrl
        [[-Mode] {Ask | Allow | Block}]
        [-GPO {Ask | Allow | Block | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderInternetAccessUnknownUrl
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderInternetAccessUnknownUrl -Mode 'Ask' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [AdobeInternetAccessUnknownUrlMode] $Mode,

        [AdobeInternetAccessUnknownUrlModeGpo] $GPO
    )

    process
    {
        $InternetAccessUnknownUrlMsg = 'Acrobat Reader - Internet Access From PDF Files: Behavior If Not In The List'

        switch ($PSBoundParameters.Keys)
        {
            'Mode'
            {
                # ask: 1 (default)| on: 2 | off: 3
                $AcrobatReaderInternetAccessUnknownUrl = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager\cDefaultLaunchURLPerms'
                    Entries = @(
                        @{
                            Name  = 'iUnknownURLPerms'
                            Value = [int]$Mode
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$InternetAccessUnknownUrlMsg' to '$Mode' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderInternetAccessUnknownUrl
            }
            'GPO'
            {
                # gpo\ TrustManager > Internet Access
                #   specifies whether to ask for, allow, or block access to web sites that are not in the user specified list
                # not configured: delete (default) | ask: 1 | on: 2 | off: 3
                $AcrobatReaderInternetAccessUnknownUrlGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cDefaultLaunchURLPerms'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'iUnknownURLPerms'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$InternetAccessUnknownUrlMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderInternetAccessUnknownUrlGpo
            }
        }
    }
}
