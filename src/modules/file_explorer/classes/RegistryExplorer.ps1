#=================================================================================================================
#                                           Classes - Registry Explorer
#=================================================================================================================

class HkcuExplorer : RegistrySetting
{
    # Constructors
    #-------------
    HkcuExplorer([string]$EntryName, [object]$Value, [string]$Type)
    {
        $this.Settings = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer'
            Entries = @(
                @{
                    Name  = $EntryName
                    Value = $Value
                    Type  = $Type
                }
            )
        }
    }
}

class HkcuExplorerAdvanced : RegistrySetting
{
    # Constructors
    #-------------
    HkcuExplorerAdvanced([string]$EntryName, [object]$Value, [string]$Type)
    {
        $this.Settings = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = $EntryName
                    Value = $Value
                    Type  = $Type
                }
            )
        }
    }
}
