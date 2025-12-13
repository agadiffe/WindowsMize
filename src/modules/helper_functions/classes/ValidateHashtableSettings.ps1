#=================================================================================================================
#                                          Base Class - Validate Hashtable Settings
#=================================================================================================================

class ValidateHashtableSettings : Hashtable
{
    # Constructors
    #-------------
    ValidateHashtableSettings([hashtable]$Settings) : base($Settings) {}


    # Methods
    #-------------
    hidden [void] ValidateSettings([hashtable]$Settings, [string[]] $KeyNames, [string[]] $KeyValues)
    {
        foreach ($Key in $Settings.Keys)
        {
            if ($KeyNames -notcontains $Key)
            {
                throw "Invalid key: $Key. Specify one of the following value: $($KeyNames -join ', ')"
            }
            if ($KeyValues -notcontains $Settings.$Key)
            {
                throw "Invalid value '$($Settings.$Key)' for the key '$Key'. " +
                      "Specify one of the following value: $($KeyValues -join ', ')"
            }
        }
    }
}
