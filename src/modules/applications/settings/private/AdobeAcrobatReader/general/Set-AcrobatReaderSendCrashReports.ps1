#=================================================================================================================
#                           Acrobat Reader - Preferences > General > Send Crash Reports
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderSendCrashReports
        [-Value] {Ask | Always | Never}
        [<CommonParameters>]
#>

function Set-AcrobatReaderSendCrashReports
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderSendCrashReports -Value 'Never'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [CrashReportsMode] $Value
    )

    process
    {
        # ask every time: 0 (default) | always: 1 | never: 2
        $AcrobatReaderSendCrashReports = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\SendCrashReports'
            Entries = @(
                @{
                    Name  = 'iSendCrashReportsOption'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Send Crash Reports' to '$Value' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderSendCrashReports
    }
}
