#=================================================================================================================
#                           Acrobat Reader - Preferences > General > Send Crash Reports
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderSendCrashReports
        [-Mode] {Ask | Always | Never}
        [<CommonParameters>]
#>

function Set-AcrobatReaderSendCrashReports
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderSendCrashReports -Mode 'Never'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AdobeCrashReportsMode] $Mode
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
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Send Crash Reports' to '$Mode' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderSendCrashReports
    }
}
