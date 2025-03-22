#=================================================================================================================
#                            Acrobat Reader - Preferences > Security > Protected View
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderProtectedView
        [-Value] {Disabled | UnsafeLocationsFiles | AllFiles}
        [<CommonParameters>]
#>

function Set-AcrobatReaderProtectedView
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderProtectedView -Value 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ProtectedViewMode] $Value
    )

    process
    {
        # off: 0 (default) | files from potentially unsafe locations: 1 | all files: 2
        $AcrobatReaderProtectedView = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager'
            Entries = @(
                @{
                    Name  = 'iProtectedView'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Protected View' to '$Value' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderProtectedView
    }
}
