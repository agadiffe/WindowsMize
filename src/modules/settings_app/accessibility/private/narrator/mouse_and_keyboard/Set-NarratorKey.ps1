#=================================================================================================================
#                                     Accessibility > Narrator > Narrator Key
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorKey
        [-Key] {CapsLock | Insert | CapsLockOrInsert}
        [<CommonParameters>]
#>

function Set-NarratorKey
{
    <#
    .EXAMPLE
        PS> Set-NarratorKey -Key 'CapsLockOrInsert'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NarratorKey] $Key
    )

    process
    {
        # CapsLock: 1 | Insert: 2 | CapsLockOrInsert: 3 (default)
        $NarratorKey = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'NarratorModifiers'
                    Value = [int]$Key
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Narrator Key' to '$Key' ..."
        Set-RegistryEntry -InputObject $NarratorKey
    }
}
