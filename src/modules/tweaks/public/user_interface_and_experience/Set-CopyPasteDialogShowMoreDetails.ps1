#=================================================================================================================
#                                      Copy/Paste Dialog - Show More Details
#=================================================================================================================

<#
.SYNTAX
    Set-CopyPasteDialogShowMoreDetails
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-CopyPasteDialogShowMoreDetails
{
    <#
    .EXAMPLE
        PS> Set-CopyPasteDialogShowMoreDetails -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $CopyPasteDialogMoreDetailsMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager'
            Entries = @(
                @{
                    Name  = 'EnthusiastMode'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Copy/Paste Dialog - Show More Details' to '$State' ..."
        Set-RegistryEntry -InputObject $CopyPasteDialogMoreDetailsMode
    }
}
