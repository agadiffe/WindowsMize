#=================================================================================================================
#                             Accessibility > Narrator > Math Reading > Auto Zoom Out
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorMathNavigationAutoZoomOut
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorMathNavigationAutoZoomOut
{
    <#
    .EXAMPLE
        PS> Set-NarratorMathNavigationAutoZoomOut -State 'Enabled'
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
        $NarratorMathNavigationAutoZoomOut = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'MathAutoZoomOut'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Math Reading: Navigation Auto Zoom Out' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorMathNavigationAutoZoomOut
    }
}
