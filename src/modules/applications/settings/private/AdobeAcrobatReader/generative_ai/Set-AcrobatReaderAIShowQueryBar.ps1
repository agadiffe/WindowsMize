#=================================================================================================================
#                  Acrobat Reader - Preferences > Generative AI > Show AI Query Bar On Document
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderAIShowQueryBar
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderAIShowQueryBar
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAIShowQueryBar -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $AcrobatReaderAIShowQueryBar = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\Gentech'
            Entries = @(
                @{
                    Name  = 'bEnableNBA'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Generative AI: Show AI Query Bar On Document' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderAIShowQueryBar
    }
}
