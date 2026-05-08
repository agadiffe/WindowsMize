#=================================================================================================================
#                                Acrobat Reader - Preferences > Units > Page Units
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderPageUnits
        [-Unit] {Points | Inches | Millimeters | Centimeters | Picas}
        [<CommonParameters>]
#>

function Set-AcrobatReaderPageUnits
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderPageUnits -Unit 'Centimeters'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AdobePageUnits] $Unit
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
                    Value = [int]$Unit
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Page Units' to '$Unit' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderPageUnits
    }
}
