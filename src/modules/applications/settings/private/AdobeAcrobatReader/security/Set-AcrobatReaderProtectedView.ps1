#=================================================================================================================
#                       Acrobat Reader - Preferences > Security (Enhanced) > Protected View
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderProtectedView
        [[-State] {Disabled | UnsafeLocationsFiles | AllFiles}]
        [-GPO {Disabled | UnsafeLocationsFiles | AllFiles | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderProtectedView
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderProtectedView -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [AdobeProtectedViewMode] $State,

        [AdobeProtectedViewModeGpo] $GPO
    )

    process
    {
        $ProtectedViewMsg = 'Acrobat Reader - Protected View'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # off: 0 (default) | files from potentially unsafe locations: 1 | all files: 2
                $AcrobatReaderProtectedView = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager'
                    Entries = @(
                        @{
                            Name  = 'iProtectedView'
                            Value = [int]$State
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ProtectedViewMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderProtectedView
            }
            'GPO'
            {
                # gpo\ TrustManager > Protected View
                #   specifies whether to never use Protected View, for files from an untrusted location, or always
                # not configured: delete (default) | off: 0 | files from potentially unsafe locations: 1 | all files: 2
                $AcrobatReaderProtectedViewGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'iProtectedView'
                            Value = [int]$GPO
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ProtectedViewMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderProtectedViewGpo
            }
        }
    }
}
