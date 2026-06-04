#=================================================================================================================
#  Accessibility > Narrator > Narrator Key > Lock The Narrator Key So I Don't Have To Press It For Each Command
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorLockKey
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorLockKey
{
    <#
    .EXAMPLE
        PS> Set-NarratorLockKey -State 'Disabled'
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
        $NarratorLockKey = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'LockNarratorKeys'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Lock The Narrator Key' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorLockKey
    }
}
