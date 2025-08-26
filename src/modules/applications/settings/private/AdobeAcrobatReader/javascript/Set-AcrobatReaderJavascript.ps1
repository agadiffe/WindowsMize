#=================================================================================================================
#                      Acrobat Reader - Preferences > Javascript > Enable Acrobat Javascript
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderJavascript
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderJavascript
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderJavascript -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $JavascriptMsg = 'Acrobat Reader - Javascript'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $AcrobatReaderJavascript = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\JSPrefs'
                    Entries = @(
                        @{
                            Name  = 'bEnableJS'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$JavascriptMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderJavascript
            }
            'GPO'
            {
                # gpo\ JSPrefs (JavaScript Controls) > JavaScript Execution Controls
                #   specifies whether to globally disable and lock JavaScript execution
                # not configured: delete (default) | off: 1
                $AcrobatReaderJavascriptGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'bDisableJavaScript'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$JavascriptMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderJavascriptGpo
            }
        }
    }
}
