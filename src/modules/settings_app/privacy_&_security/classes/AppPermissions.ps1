#=================================================================================================================
#                                            App Permissions - Classes
#=================================================================================================================

class AppPermissionSetting : RegistrySetting
{
    # Properties
    #-------------
    [string] $State


    # Constructors
    #-------------
    AppPermissionSetting() {}

    AppPermissionSetting([object]$Settings) : base($Settings) {}


    # Methods
    #-------------
    [void] WriteVerboseMsg([string]$Message, [string]$State)
    {
        ([RegistrySetting]$this).WriteVerboseMsg("App Permissions - $Message", $State)
    }

    [void] WriteVerboseMsg([string]$Message)
    {
        $this.WriteVerboseMsg($Message, $this.State)
    }
}

class AppPermissionAccess : AppPermissionSetting
{
    # Notes
    #-------------
    # 'HKEY_LOCAL_MACHINE' is for the main toggle. e.g. Camera access
    # 'HKEY_CURRENT_USER' is for the application toggle. e.g. Let apps access your camera


    # Properties
    #-------------
    [string[]] $NoHkcuToggle = 'passkeys', 'passkeysEnumeration'


    # Constructors
    #-------------
    AppPermissionAccess([string]$KeyName, [string]$State)
    {
        $this.State = $State
        $Value = $State -eq 'Enabled' ? 'Allow' : 'Deny'
        $CurrentTime = (Get-Date).ToFileTime()

        $this.Settings = @(
            @{
                SkipKey = $KeyName -in $this.NoHkcuToggle
                Hive    = 'HKEY_CURRENT_USER'
                Path    = "Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\$KeyName"
                Entries = @(
                    @{
                        Name  = 'Value'
                        Value = $Value
                        Type  = 'String'
                    }
                    @{
                        Name  = 'LastSetTime'
                        Value = $CurrentTime
                        Type  = 'QWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = "SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\$KeyName"
                Entries = @(
                    @{
                        Name  = 'Value'
                        Value = $Value
                        Type  = 'String'
                    }
                    @{
                        Name  = 'LastSetTime'
                        Value = $CurrentTime
                        Type  = 'QWord'
                    }
                )
            }
        )
    }
}

class AppPermissionPolicy : AppPermissionSetting
{
    # Constructors
    #-------------
    AppPermissionPolicy([string]$EntryName, [string]$GPO)
    {
        $this.State = $GPO
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        $this.Settings = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\AppPrivacy'
            Entries = @(
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = $EntryName
                    Value = $GPO -eq 'Enabled' ? '1' : '2'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = "${EntryName}_ForceAllowTheseApps"
                    Value = $null
                    Type  = 'MultiString'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = "${EntryName}_ForceDenyTheseApps"
                    Value = $null
                    Type  = 'MultiString'
                }
                @{
                    RemoveEntry = $IsNotConfigured
                    Name  = "${EntryName}_UserInControlOfTheseApps"
                    Value = $null
                    Type  = 'MultiString'
                }
            )
        }
    }
}
