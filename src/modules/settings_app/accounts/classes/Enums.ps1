#==============================================================================
#                               Accounts - Enums
#==============================================================================

# your info
enum BlockMSAccountsMode
{
    CannotAddMicrosoftAccount            = 1
    CannotAddOrLogonWithMicrosoftAccount = 3
    NotConfigured
}


# sign-in options
enum SigninRequiredS0
{
    Never
    Always
    OneMin
    ThreeMins
    FiveMins
    FifteenMins
}

enum SigninRequiredS3
{
    Never
    OnWakesUpFromSleep
}
