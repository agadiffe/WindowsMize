#=================================================================================================================
#                                Acrobat Reader - Preferences > Units > Page Units
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderPageUnits
        [-Value] {Points | Inches | Millimeters | Centimeters | Picas}
        [<CommonParameters>]
#>

function Set-AcrobatReaderPageUnits
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderPageUnits -Value 'Centimeters'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AdobePageUnits] $Value
    )

    process
    {
        # points: 0 | inches: 1 | millimeters: 2 | centimeters: 3 | picas: 4
        $AcrobatReaderPageUnits = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\Originals'
            Entries = @(
                @{
                    Name  = 'iPageUnits'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Page Units' to '$Value' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderPageUnits
    }
}
