#=================================================================================================================
#                                      Validate Drive Path Attribute - Class
#=================================================================================================================

class ValidateDrivePathAttribute : System.Management.Automation.ValidateArgumentsAttribute
{
    [void] Validate([object]$Arg, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics)
    {
        $FileSystemDrives = (Get-PSDrive -PSProvider 'FileSystem').Name

        foreach ($Item in $Arg)
        {
            if ($Item -notmatch '^[A-Za-z]:\\?$')
            {
                throw [System.Management.Automation.ValidationMetadataException]::new(
                    'Drive format must be a letter followed by a colon, optionally with a backslash (e.g. ''C:'' or ''C:\'').'
                )
            }

            if ($FileSystemDrives -notcontains $Item[0])
            {
                throw [System.Management.Automation.ValidationMetadataException]::new(
                    'The specified drive does not exist or is not accessible.'
                )
            }
        }
    }
}
