#=================================================================================================================
#                Acrobat Reader - Preferences > Reviewing > Show Welcome Dialog When Opening File
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderSharedReviewWelcomeDialog
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderSharedReviewWelcomeDialog
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderSharedReviewWelcomeDialog -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (defaukt) | off: 0
        $AcrobatReaderSharedReviewWelcomeDialog = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\Collab'
            Entries = @(
                @{
                    Name  = 'bShowWelcomeDialog'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Reviewing: Show Welcome Dialog When Opening File' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderSharedReviewWelcomeDialog
    }
}
