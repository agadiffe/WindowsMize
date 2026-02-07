#=================================================================================================================
#                                                 Test File Lock
#=================================================================================================================

<#
.SYNTAX
    Test-FileLock
        [-FilePath] <string>
        [<CommonParameters>]
#>

function Test-FileLock
{
    <#
    .EXAMPLE
        PS> $FilePath = "C:\Users\User\AppData\Local\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\Settings\settings.dat"
        PS> Test-FileLock -FilePath $FilePath
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath
    )

    process
    {
        try
        {
            $FileStream = [System.IO.File]::Open($FilePath, 'Open', 'ReadWrite', 'None')
            $FileStream.Close()
            $IsLocked = $false
        }
        catch
        {
            $IsLocked = $true
        }
        $IsLocked
    }
}
