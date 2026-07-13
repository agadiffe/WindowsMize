#=================================================================================================================
#             Acrobat Reader - Preferences > Generative AI > Enable Generative AI Feature In Acrobat
#=================================================================================================================

# Data are processed in the cloud.

<#
.SYNTAX
    Set-AcrobatReaderAI
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderAI
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAI -State 'Disabled'
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
        $AcrobatReaderAI = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\Gentech'
            Entries = @(
                @{
                    Name  = 'bConsentProvided'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Generative AI' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderAI
    }
}
