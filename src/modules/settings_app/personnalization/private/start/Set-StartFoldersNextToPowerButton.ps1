#=================================================================================================================
#                                       Personnalization > Start > Folders
#=================================================================================================================

# Windows 11 only (Win10 use different values & logic to build the binary data).

# Choose which folders appear on Start next to the Power button

<#
.SYNTAX
    Set-StartFoldersNextToPowerButton
        [-Value] {Settings | FileExplorer | Network | PersonalFolder |
                  Documents | Downloads | Music | Pictures | Videos}
        [<CommonParameters>]

    Set-StartFoldersNextToPowerButton
        -None
        [<CommonParameters>]
#>

function Set-StartFoldersNextToPowerButton
{
    <#
    .EXAMPLE
        PS> Set-StartFoldersNextToPowerButton -Value 'Settings', 'PersonalFolder'

    .EXAMPLE
        PS> Set-StartFoldersNextToPowerButton -None
    #>

    [CmdletBinding(DefaultParameterSetName = 'Value')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Value')]
        [StartFoldersName[]] $Value,

        [Parameter(Mandatory, ParameterSetName = 'None')]
        [switch] $None
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'None')
        {
            if ($false -eq $None)
            {
                return
            }
            $StartFoldersBytes = ''
        }
        else
        {
            $StartFolders = [System.Collections.ArrayList]::new()

            switch ($Value)
            {
                'Settings'       { $StartFolders.Add('86,08,73,52,aa,51,43,42,9f,7b,27,76,58,46,59,d4') | Out-Null }
                'FileExplorer'   { $StartFolders.Add('bc,24,8a,14,0c,d6,89,42,a0,80,6e,d9,bb,a2,48,82') | Out-Null }
                'Documents'      { $StartFolders.Add('ce,d5,34,2d,5a,fa,43,45,82,f2,22,e6,ea,f7,77,3c') | Out-Null }
                'Downloads'      { $StartFolders.Add('2f,b3,67,e3,de,89,55,43,bf,ce,61,f3,7b,18,a9,37') | Out-Null }
                'Music'          { $StartFolders.Add('20,06,0b,b0,51,7f,32,4c,aa,1e,34,cc,54,7f,73,15') | Out-Null }
                'Pictures'       { $StartFolders.Add('a0,07,3f,38,0a,e8,80,4c,b0,5a,86,db,84,5d,bc,4d') | Out-Null }
                'Videos'         { $StartFolders.Add('c5,a5,b3,42,86,7d,f4,42,80,a4,93,fa,ca,7a,88,b5') | Out-Null }
                'Network'        { $StartFolders.Add('44,81,75,fe,0d,08,ae,42,8b,da,34,ed,97,b6,63,94') | Out-Null }
                'PersonalFolder' { $StartFolders.Add('4a,b0,bd,74,4a,f9,68,4f,8b,d6,43,98,07,1d,a8,bc') | Out-Null }
            }

            $StartFoldersValue = $StartFolders -join ','
            $StartFoldersBytes = $StartFoldersValue.Split(',') | ForEach-Object -Process { [byte]"0x$_" }
        }

        # only Power button: empty value (default)
        $StartFoldersNextToPowerButton = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = 'VisiblePlaces'
                    Value = $StartFoldersBytes
                    Type  = 'Binary'
                }
            )
        }

        $StartFoldersShown = $StartFoldersBytes -eq '' ? 'None' : ($Value -join ', ')

        Write-Verbose -Message "Setting 'Start - Folders Next To The Power Button' to '$StartFoldersShown' ..."
        Set-RegistryEntry -InputObject $StartFoldersNextToPowerButton
    }
}
