#=================================================================================================================
#                           Acrobat Reader - Preferences > General > Show Cloud Storage
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderShowCloudStorage
        [-OnFileOpen {Disabled | Enabled}]
        [-OnFileSave {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderShowCloudStorage
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderShowCloudStorage -OnFileOpen 'Disabled' -OnFileSave 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $OnFileOpen,

        [state] $OnFileSave
    )

    process
    {
        $AcrobatCloudStorageMsg = 'Acrobat Reader - Show Cloud Storage'

        switch ($PSBoundParameters.Keys)
        {
            'OnFileOpen'
            {
                # on: 0 | off: 1 (default)
                $AcrobatReaderCloudStorageOnFileOpen = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral'
                    Entries = @(
                        @{
                            Name  = 'bToggleCustomOpenExperience'
                            Value = $OnFileOpen -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AcrobatCloudStorageMsg When Openings Files' to '$OnFileOpen' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderCloudStorageOnFileOpen
            }
            'OnFileSave'
            {
                # on: 0 (default) | off: 1
                $AcrobatReaderCloudStorageOnFileSave = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral'
                    Entries = @(
                        @{
                            Name  = 'bToggleCustomSaveExperience'
                            Value = $OnFileSave -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$AcrobatCloudStorageMsg When Saving Files' to '$OnFileSave' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderCloudStorageOnFileSave
            }
        }
    }
}
