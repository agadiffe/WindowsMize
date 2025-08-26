#=================================================================================================================
#                     Acrobat Reader - Preferences > Security (Enhanced) > Enhanced Security
#=================================================================================================================

# The GUI checkbox sets both keys bEnhancedSecurityStandalone and bEnhancedSecurityInBrowser.

# Enhanced security blockes 6 specific behaviors: data injection, script injection, silent printing,
# web links (if not allowed by Trust Manager settings), cross domain access, and access to external streams.

<#
.SYNTAX
    Set-AcrobatReaderEnhancedSecurity
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderEnhancedSecurity
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderEnhancedSecurity -State 'Enabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $EnhancedSecurityMsg = 'Acrobat Reader - Enhanced Security'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $Value = $State -eq 'Enabled' ? '1' : '0'

                # on: 1 (default) | off: 0
                $AcrobatReaderEnhancedSecurity = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager'
                    Entries = @(
                        @{
                            Name  = 'bEnhancedSecurityInBrowser'
                            Value = $Value
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'bEnhancedSecurityStandalone'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$EnhancedSecurityMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderEnhancedSecurity
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'
                $ValueGpo = $GPO -eq 'Enabled' ? '1' : '0'

                # gpo\ TrustManager > Enhanced Security
                #   toggles enhanced security when the application is running in the browser
                #   toggles enhanced security for the standalone application
                # not configured: delete (default) | on: 1 | off: 0
                $AcrobatReaderEnhancedSecurityGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'bEnhancedSecurityInBrowser'
                            Value = $ValueGpo
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'bEnhancedSecurityStandalone'
                            Value = $ValueGpo
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$EnhancedSecurityMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderEnhancedSecurityGpo
            }
        }
    }
}
