#=================================================================================================================
#                                          Registry Setting - Base Class
#=================================================================================================================

class RegistrySetting
{
    # Properties
    #-------------
    [object] $Settings


    # Constructors
    #-------------
    RegistrySetting() {}

    RegistrySetting([object]$Settings)
    {
        $this.Settings = $Settings
    }


    # Methods
    #-------------
    [void] SetRegistryEntry()
    {
        $this.Settings | Set-RegistryEntry
    }

    [void] WriteVerboseMsg([string]$Message, [string]$State)
    {
        Write-Verbose -Message "Setting '$Message' to '$State' ..."
    }
}
