#=================================================================================================================
#                                         MSOffice - Misc > Teaching Tips
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeTeachingTips
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MSOfficeTeachingTips
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeTeachingTips -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 or delete (default) | off: 1
        $MSOfficeTeachingTips = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Office\16.0\Common\TeachingCallouts'
            Entries = @(
                @{
                    Name  = 'DontShowTeachingCallouts'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'MSOffice - Teaching Tips' to '$State' ..."
        Set-RegistryEntry -InputObject $MSOfficeTeachingTips
    }
}
