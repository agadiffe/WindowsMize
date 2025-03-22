#==============================================================================
#                                 Apps - Enums
#==============================================================================

enum AppInstallControl
{
    Anywhere
    AnywhereWithStoreNotif
    AnywhereWithWarnIfNotStore
    StoreOnly
}

enum GpoAppInstallControl
{
    Anywhere
    AnywhereWithStoreNotif
    AnywhereWithWarnIfNotStore
    StoreOnly
    NotConfigured
}

enum ShareAcrossDevicesMode
{
    Disabled       = 0
    DevicesOnly    = 1
    EveryoneNearby = 2
}
