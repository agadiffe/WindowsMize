#=================================================================================================================
#                                             Class - Registry Entry
#=================================================================================================================

class RegistryEntry
{
    [bool] $SkipKey
    [bool] $RemoveKey

    [ValidateSet(
        'HKEY_CLASSES_ROOT',
        'HKEY_CURRENT_USER',
        'HKEY_LOCAL_MACHINE',
        'HKEY_USERS',
        'HKEY_CURRENT_CONFIG')]
    [string] $Hive

    [string] $Path
    [RegistryKeyEntry[]] $Entries
}

class RegistryKeyEntry
{
    [bool] $RemoveEntry
    [string] $Name
    [object] $Value

    [ValidateSet(
        'String',
        'ExpandString',
        'MultiString',
        'Binary',
        'DWord',
        'QWord')]
    [string] $Type
}
