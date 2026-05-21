#=================================================================================================================
#                     Personnalization > Start > Hide Your Name And Profile Picture On Start
#=================================================================================================================

# not yet available

<#
.SYNTAX
    Set-StartHideNameAndPicture
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartHideNameAndPicture
{
    <#
    .EXAMPLE
        PS> Set-StartHideNameAndPicture -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        return

        # on: 1 | off: 0 (default)
        $HideNameAndPicture = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = '???'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Hide Your Name And Profile Picture On Start' to '$State' ..."
        Set-RegistryEntry -InputObject $HideNameAndPicture
    }
}
