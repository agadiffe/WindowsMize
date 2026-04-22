#=================================================================================================================
#                                            Brave Browser Config Data
#=================================================================================================================

<#
.SYNTAX
    New-BraveBrowserConfigData [<CommonParameters>]
#>

function New-BraveBrowserConfigData
{
    [CmdletBinding()]
    param ()

    process
    {
        $BraveLocalState = @{}
        $BravePreferences = @{}

        #------------------------------------
        ## brave://flags
        #------------------------------------
        #region flags

        Merge-Hashtable $BraveLocalState ('{
            "browser": {
                "enabled_labs_experiments": [
                    //"brave-adblock-show-hidden-components@1", // show hidden adblock filter list
                    "brave-v8-jitless-mode@1", // enable V8 jitless mode when optimizations are disabled
                    //"enable-force-dark@1", // auto dark mode for web content
                    "enable-gpu-rasterization@1",
                    "enable-parallel-downloading@1"
                ]
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion flags

        #------------------------------------
        ## Get started
        #------------------------------------
        #region get started

        ### New Tab Page
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "brave_search": {
                    "show-ntp-search": false // search widgets
                },
                "new_tab_page": {
                    "clock_format": "", // automatic: empty string | 12-hour-clock: h12 | 24-hour-clock: h24
                    "show_background_image": true,
                    "show_branded_background_image": false, // ads
                    "show_brave_news": false,
                    "show_brave_vpn": false,
                    "show_clock": false,
                    "show_rewards": false,
                    "show_stats": false,
                    "show_together": false, // Brave talk
                    "shows_options": 0 // new tab page\ dashboard: 0 | homepage: 1 | blank page: 2
                }
            },
            "ntp": {
                "shortcust_visible": false, // top sites
                "shortcuts_type": 1 // Favorites: 1 | Frequently Visited: 0
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion get started

        #------------------------------------
        ## Appearance
        #------------------------------------
        #region appearance

        # show bookmarks:
        #              show_on_all_tabs | always_show_bookmark_bar_on_ntp
        #     always :      true               true or false (ignored)
        #      never :      false              false
        #   ntp only :      false              true
        Merge-Hashtable $BravePreferences ('{
            "bookmark_bar": {
                "show_on_all_tabs": true
            },
            "brave": {
                "always_show_bookmark_bar_on_ntp": true
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BravePreferences ('{
            "bookmark_bar": {
                "show_tab_groups": false
            },
            "auto_pin_new_tab_groups": false,
            "brave": {
                "autocomplete_enabled": true,
                "top_site_suggestions_enabled": false, // on-device suggestions
                "omnibox": {
                    "history_suggestions_enabled": true,
                    "bookmark_suggestions_enabled": true,
                    "commander_suggestions_enabled": true // quick commands
                },
                "ai_chat": {
                    "autocomplete_provider_enabled": false // Leo suggestions in address bar
                },
                "location_bar_is_wide": false,
                "omnibox": {
                    "prevent_url_elisions": false // show full URLs
                },
                "web_view_rounded_corners": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Theme
        #---------------
        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "dark_mode": 0 // device: 0 | dark: 1 | light: 2
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "darker_mode": false // ultra dark theme
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Customize your toolbar
        #---------------
        #### Navigation
        Merge-Hashtable $BravePreferences ('{
            "browser": {
                "show_forward_button": true,
                "pin_split_tab_button": false // split view
            },
            "brave": {
                "show_bookmarks_button": true,
                "show_side_panel_button": false, // Sidebar
                "wallet": {
                    "show_wallet_icon_on_toolbar": false
                },
                "ai_chat": {
                    "show_toolbar_button": false // Leo AI
                },
                "brave_vpn": {
                    "show_button": false
                }
            },
            "toolbar": {
                "pinned_actions": [
                    //"kActionNewIncognitoWindow", // new private window
                    "kActionTabSearch"
                ]
            }
        }' | ConvertFrom-Json -AsHashtable)

        #### Toolbar
        Merge-Hashtable $BravePreferences ('{
            "toolbar": {
                "pinned_actions": [
                    //"kActionShowPasswordsBubbleOrPage",
                    //"kActionSidePanelShowBookmarks",
                    //"kActionSidePanelShowReadingList",
                    //"kActionShowDownloads",
                    //"kActionClearBrowsingData"
                ]
            }
        }' | ConvertFrom-Json -AsHashtable)

        #### Tools and actions
        Merge-Hashtable $BravePreferences ('{
            "toolbar": {
                "pinned_actions": [
                    //"kActionPrint",
                    //"kActionQrCodeGenerator",
                    //"kActionRouteMedia", // cast
                    //"kActionCopyUrl",
                    //"kActionSendTabToSelf", // send to your devices
                    //"kActionTaskManager",
                    //"kActionDevTools"
                ]
            }
        }' | ConvertFrom-Json -AsHashtable)

        #### Adress bar
        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "rewards": {
                    "show_brave_rewards_button_in_location_bar": false
                },
                "today": {
                    "should_show_toolbar_button": false // RSS feed
                },
                "pin_share_menu_button": false
            },
            "browser": {
                "pin_pwa_install_button": false // install app
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Tabs
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "tabs": {
                    "vertical_tabs_enabled": false,
                    "vertical_tabs_show_title_on_window": true,
                    "vertical_tabs_collapsed": false,
                    "vertical_tabs_hide_completely_when_collapsed": false,
                    "vertical_tabs_floating_enabled": true, // expand on hover when minimized
                    "vertical_tabs_expanded_state_per_window": true, // expand independently per window
                    "vertical_tabs_show_scrollbar": false,
                    "vertical_tabs_on_right": false,
                    "mute_indicator_not_clickable": false,
                    "always_hide_tab_close_button": false,
                    "middle_click_close_tab_enabled": true,
                    "hover_mode": 0 // tooltip: 0 | card: 1 | card with preview: 2
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BraveLocalState ('{
            "browser": {
                "hovercard": {
                    "memory_usage_enabled": false
                }
            },
            "performance_tuning": {
                "discard_ring_treatment": {
                    "enabled": false // inactive tabs appearance
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Sidebar
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "sidebar": {
                    "sidebar_show_option": 3 // always: 0 | on mouseover: 1 | never: 3
                }
            },
            "side_panel": {
                "is_right_aligned": true
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion appearance

        #------------------------------------
        ## Content
        #------------------------------------
        #region content

        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "mru_cycling_enabled": false, // cycle through the most recently used tabs
                "wayback_machine_enabled": false,
                "speedreader": {
                    "feature_enabled": false,
                    "enabled_for_all_sites": false // auto use when possible
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion content

        #------------------------------------
        ## Shields
        #------------------------------------
        #region shields

        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "shields": {
                    "stats_badge_visible": false // number on the Shields icon
                },
                "no_script_default": false,
                "webcompat": {
                    "report": {
                        "enable_save_contact_info": false // store contact info for future broken site reports
                    }
                }
            },
            "profile": {
                "content_settings": {
                    "exceptions": {
                        "fingerprintingV2": {
                            "*,*": {
                                "setting": 3 // on: 3 | off: 1
                            }
                        },
                        "cosmeticFiltering": { // tackers & ads
                            "*,*": {
                                "setting": 2 // agressive/standard: 2 | off: 1
                            },
                            "*,https://firstparty": {
                                "setting": 2 // agressive: 2 | standard/off: 1
                            }
                        },
                        "shieldsAds": { // tackers & ads
                            "*,*": {
                                "setting": 2 // agressive/standard: 2 | off: 1
                            }
                        },
                        "trackers": { // tackers & ads
                            "*,*": {
                                "setting": 2 // agressive/standard: 2 | off: 1
                            }
                        }
                    }
                },
                "default_content_setting_values": {
                    "brave_remember_1p_storage": 1, // forget me when I close this site\ on: 2 | off: 1
                    "httpsUpgrades": 2 // strict: 2 | standard: 3 | off: 1
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "allow_element_blocker_in_private_mode": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        # if "on-device site data" is set to "dont allow sites to save data" : "block cookies" must be set to "1".
        #  it will also set the "block cookies" GUI option to "block all".
        Merge-Hashtable $BravePreferences ('{
            "profile": {
                "cookie_controls_mode": 1, // block cookies\ block third-party: 1 | allow all: 0
                "default_content_setting_values": {
                    "cookies": 1 // on-device site data\ allow: 1 | delete when close: 4 | dont allow: 2
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #### Content Filtering
        #---------------
        # Uncomment if you need custom filters.
        <#
        $BraveCustomFilters = @(
            '||example.com^'
            '||example.org^'
        ) -join '\n'
        #>

        #### custom filter lists
        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "ad_block": {
                    "custom_filters": "$BraveCustomFilters",
                    "list_subscriptions": {
                        "https://filters.adtidy.org/extension/ublock/filters/3.txt": {
                            "enabled": false, // AdGuard Tracking Protection
                            "last_successful_update_attempt": "1",
                            "last_update_attempt": "1"
                        },
                        "https://gitlab.com/DandelionSprout/adfilt/-/raw/master/LegitimateURLShortener.txt": {
                            "enabled": false, // Actually Legitimate URL Shortener Tool (not fully compatible with Brave)
                            "last_successful_update_attempt": "1",
                            "last_update_attempt": "1"
                        },
                        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.mini.txt": {
                            "enabled": false, // HaGeZi DNS Blocklist (light, multi, pro(.mini), pro.plus(.mini), ultimate(.mini))
                            "last_successful_update_attempt": "1",
                            "last_update_attempt": "1"
                        },
                        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/tif.medium.txt": {
                            "enabled": false, // HaGeZi Threat Intelligence Feeds DNS Blocklist (tif) (.medium, .mini)
                            "last_successful_update_attempt": "1",
                            "last_update_attempt": "1"
                        },
                        "https://secure.fanboy.co.nz/fanboy-antifacebook.txt": {
                            "enabled": false, // Fanboy Anti-Facebook
                            "last_successful_update_attempt": "1",
                            "last_update_attempt": "1"
                        },
                        "https://secure.fanboy.co.nz/fanboy-antifonts.txt": {
                            "enabled": false, // Fanboy Anti-thirdparty Fonts
                            "last_successful_update_attempt": "1",
                            "last_update_attempt": "1"
                        }
                    }
                }
            }
        }'.Replace('$BraveCustomFilters', $BraveCustomFilters) | ConvertFrom-Json -AsHashtable)

        #### filter lists - general
        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "ad_block": {
                    "regional_filters": {
                        "AC023D22-AE88-4060-A978-4FEEEC4221693": {
                            "enabled": false // Cookie notice blocker (included in Annoying distractions)
                        },
                        "67E792D4-AE03-4D1A-9EDE-80E01C81F9B8": {
                            "enabled": true // Annoying distractions blocker
                        },
                        "6B91E355-1421-4C03-9A30-911B4D0FB277": {
                            "enabled": false // AI suggestions blocker
                        },
                        "690FF3B4-8B6B-4709-8505-FEC6643D7BD9": {
                            "enabled": false // Newsletter popup blocker (included in Annoying distractions)
                        },
                        "2F3DCE16-A19A-493C-A88F-2E110FBD37D6": {
                            "enabled": false // Mobile app promo blocker (included in Annoying distractions)
                        },
                        "7911A1CB-304E-4CDB-ABB3-E2A94A37E4DD": {
                            "enabled": false // Social media blocker (included in Annoying distractions)
                        },
                        "E2FA7D98-0BD5-493E-8AF4-950604ADE9CB": {
                            "enabled": true // Tracking URL blocker
                        },
                        "1ED1870B-997C-4BFE-AEBC-B67D679BAF3B": {
                            "enabled": false // Chat app blocker
                        },
                        "78672887-A098-4D2C-B0CB-A3DEC4834DA7": {
                            "enabled": false // Paywall blocker
                        },
                        "F61D6B7B-4110-4EA4-9C81-38FB4CE90AEC": {
                            "enabled": false // Porn blocker
                        },
                        "564C3B75-8731-404C-AD7C-5683258BA0B0": {
                            "enabled": false // Experimental ad blocker
                        }
                    }
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #### filter lists - YouTube
        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "ad_block": {
                    "regional_filters": {
                        "9E8EC586-4E17-4E5E-99D7-35172C4CEA74": {
                            "enabled": false // YouTube Shorts blocker
                        },
                        "5C6A6C95-B60A-4695-9EFB-539359022531": {
                            "enabled": false // YouTube Playables blocker
                        },
                        "2D57ADED-3531-419A-9DED-7F8868BC1561": {
                            "enabled": false // YouTube recommendations blocker (mobile-only)
                        },
                        "7F11B964-4F36-4E06-9D75-BD16381B9386": {
                            "enabled": false // YouTube autodubbed videos blocker
                        },
                        "D579F370-6DE3-4507-AA9A-CEE4227E59F5": {
                            "enabled": false // YouTube end video elements blocker
                        },
                        "49958DA7-F532-4A84-A765-9501729B8E75": {
                            "enabled": false // YouTube members-only video blocker
                        },
                        "BD308B90-D3BB-4041-9114-22E096B0BA77": {
                            "enabled": false // YouTube distractions elements blocker (mobile-only)
                        },
                        "3AFA9D35-D837-45B5-B742-B3D0FE94E77C": {
                            "enabled": false // YouTube thumbnail image blocker
                        }
                    }
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #### filter lists - regional
        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "ad_block": {
                    "regional_filters": {
                        "9FCEECEC-52B4-4487-8E57-8781E82C91D0": {
                            "enabled": false // Arabic website ad blocker
                        },
                        "FD176DD1-F9A0-4469-B43E-B1764893DD5C": {
                            "enabled": false // Bulgarian website ad blocker
                        },
                        "92AA0D3B-34AC-4657-9A5C-DBAD339AF8E2": {
                            "enabled": false // Chinese website ad blocker
                        },
                        "CC98E4BA-9257-4386-A1BC-1BBF6980324F": {
                            "enabled": false // Chinese website annoyances blocker
                        },
                        "7CCB6921-7FDA-4A9B-B70A-12DD0A8F08EA": {
                            "enabled": false // Czech and Slovak website ad blocker
                        },
                        "9D644676-4784-4982-B94D-C9AB19098D2A": {
                            "enabled": false // Dutch website ad blocker
                        },
                        "0783DBFD-B5E0-4982-9B4A-711BDDB925B7": {
                            "enabled": false // Estonian website ad blocker
                        },
                        "1C6D8556-3400-4358-B9AD-72689D7B2C46": {
                            "enabled": false // Finnish website ad blocker
                        },
                        "9852EFC4-99E4-4F2D-A915-9C3196C7A1DE": {
                            "enabled": false // French website ad blocker
                        },
                        "E71426E7-E898-401C-A195-177945415F38": {
                            "enabled": false // German website ad blocker
                        },
                        "6C0F4C7F-969B-48A0-897A-14583015A587": {
                            "enabled": false // Greek website ad blocker
                        },
                        "85F65E06-D7DA-4144-B6A5-E1AA965D1E47": {
                            "enabled": false // Hebrew website ad blocker
                        },
                        "4C07DB6B-6377-4347-836D-68702CF1494A": {
                            "enabled": false // Hindi website ad blocker
                        },
                        "EDEEE15A-6FA9-4FAC-8CA8-3565508EAAC3": {
                            "enabled": false // Hungarian website ad blocker
                        },
                        "48796273-E783-431E-B864-44D3DCEA66DC": {
                            "enabled": false // Icelandic website ad blocker
                        },
                        "93123971-5AE6-47BA-93EA-BE1E4682E2B6": {
                            "enabled": false // Indonesian website ad blocker
                        },
                        "AB1A661D-E946-4F29-B47F-CA3885F6A9F7": {
                            "enabled": false // Italian website ad blocker
                        },
                        "03F91310-9244-40FA-BCF6-DA31B832F34D": {
                            "enabled": false // Japanese website ad blocker
                        },
                        "45B3ED40-C607-454F-A623-195FDD084637": {
                            "enabled": false // Korean website ad blocker
                        },
                        "15B64333-BAF9-4B77-ADC8-935433CD6F4C": {
                            "enabled": false // Latvian website ad blocker
                        },
                        "4E8B1A63-DEBE-4B8B-AD78-3811C632B353": {
                            "enabled": false // Lithuanian website ad blocker
                        },
                        "7BC951C6-B0B8-4223-97FC-3C22605734FC": {
                            "enabled": false // Macedonian website ad blocker
                        },
                        "8BEDBAA8-4FE2-4FEA-82F2-81B8124A4A74": {
                            "enabled": false // Nordic website ad blocker
                        },
                        "C3C2F394-D7BB-4BC2-9793-E0F13B2B5971": {
                            "enabled": false // Persian website ad blocker
                        },
                        "BF9234EB-4CB7-4CED-9FCB-F1FD31B0666C": {
                            "enabled": false // Polish website ad blocker
                        },
                        "AD3E8454-F376-11E8-8EB2-F2801F1B9FD1": {
                            "enabled": false // Romanian website ad blocker
                        },
                        "1088D292-2369-4D40-9BDF-C7DC03C05966": {
                            "enabled": false // Russian website ad blocker - AdGuard Russian
                        },
                        "80470EEC-970F-4F2C-BF6B-4810520C72E6": {
                            "enabled": false // Russian website ad blocker - RU AdList
                        },
                        "418D293D-72A8-4A28-8718-A1EE40A45AAF": {
                            "enabled": false // Slovenian website ad blocker
                        },
                        "AE657374-1851-4DC4-892B-9212B13B15A7": {
                            "enabled": false // Spanish website ad blocker
                        },
                        "1FEAF960-F377-11E8-8EB2-F2801F1B9FD1": {
                            "enabled": false // Spanish and Portuguese website ad blocker
                        },
                        "7DC2AC80-5BBC-49B8-B473-A31A1145CAC1": {
                            "enabled": false // Swedish website ad blocker
                        },
                        "658F092A-F377-11E8-8EB2-F2801F1B9FD1": {
                            "enabled": false // Thai website ad blocker
                        },
                        "1BE19EFD-9191-4560-878E-30ECA72B5B3C": {
                            "enabled": false // Turkish website ad blocker
                        },
                        "6A0209AC-9869-4FD6-A9DF-039B4200D52C": {
                            "enabled": false // Vietnamese website ad blocker
                        }
                    }
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Social media blocking
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "fb_embed_default": false, // Facebook
                "twitter_embed_default": false,
                "linkedin_embed_default": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion shields

        #------------------------------------
        ## Privacy and security
        #------------------------------------
        #region privacy

        Merge-Hashtable $BravePreferences ('{
            "webrtc": {
                // default | default_public_and_private_interfaces | default_public_interface_only | disable_non_proxied_udp
                "ip_handling_policy": "disable_non_proxied_udp"
            },
            "brave": {
                "gcm": {
                    "channel_status": false // google for push messaging
                },
                "de_amp": {
                    "enabled": true // auto-redirect AMP pages
                },
                "debounce": {
                    "enabled": true // auto-redirect tracking urls
                },
                "reduce_language": true // prevent fingerprinting based on language
            },
            "enable_do_not_track": false
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "windows_recall_disabled": true
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Clear Browsing data
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "browser": {
                "clear_data": {
                    "brave_leo_on_exit": false,
                    "browsing_history_on_exit": false,
                    "cache_on_exit": false,
                    "cookies_on_exit": false,
                    "download_history_on_exit": false,
                    "form_data_on_exit": false,
                    "hosted_apps_data_on_exit": false,
                    "passwords_on_exit": false,
                    "site_settings_on_exit": false
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Security
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "safebrowsing": {
                "enabled": true
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BraveLocalState ('{
            "dns_over_https": { // use secure DNS
                "mode": "automatic", // OS default: automatic | add custom DNS service provider: secure | off: off
                "templates": "" // automatic: empty | custom (i.e. secure): e.g. https://cloudflare-dns.com/dns-query
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Site and Shields Settings
        #---------------
        # for 'on-device site data' see 'Shields > cookie_controls_mode'
        Merge-Hashtable $BravePreferences ('{
            "profile": {
                "default_content_setting_values": { // on: 1 | off: 2
                    "ar": 2, // augmented reality
                    "auto_picture_in_picture": 2,
                    "automatic_downloads": 1,
                    "autoplay": 1,
                    "brave_cardano": 2,
                    "brave_ethereum": 2,
                    "brave_google_sign_in": 2,
                    "brave_open_ai_chat": 2,
                    "brave_solana": 2,
                    "captured_surface_control": 2, // shared tabs
                    "clipboard": 2,
                    "file_system_write_guard": 2, // file editing
                    "geolocation": 2,
                    "hand_tracking": 2,
                    "hid_guard": 2, // HID devices
                    "images": 1,
                    "javascript_optimizer": 2, // v8 optimizer
                    "local_fonts": 2, // fonts
                    "local_network": 2,
                    "loopback_network": 2, // apps on device
                    "media_stream_camera": 2,
                    "media_stream_mic": 2,
                    "midi_sysex": 2, // MIDI device control & reprogram
                    "notifications": 2,
                    "payment_handler": 2,
                    "popups": 2, // pop-ups and redirects
                    "protected_media_identifier": 2, // protected content IDs
                    "sensors": 2, // motion sensors
                    "serial_guard": 2, // serial ports
                    "sound": 1,
                    "usb_guard": 2, // USB devices
                    "vr": 2, // virtual reality
                    "web_app_installation": 2,
                    "window_placement": 2 // window management
                }
            },
            "custom_handlers": {
                "enabled": false // protocol handlers
            },
            "plugins": {
                "always_open_pdf_externally": false // open in Brave: false | download pdf: true
            },
            "webkit": {
                "webprefs": {
                    "encrypted_media_enabled": true // play protected content
                }
            },
            "safety_hub": {
                "unused_site_permissions_revocation": {
                    "enabled": true
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        # geolocation and/or notifications: if default_content_setting_values is enabled.
        #        requests     | cpss  | quiet perm
        #          expand all : false   false
        #   collapse unwanted : true    false
        #        collapse all : false   true
        Merge-Hashtable $BravePreferences ('{
            "profile": {
                "content_settings": {
                    "enable_cpss": {
                        "geolocation": true,
                        "notifications": true
                    },
                    "enable_quiet_permission_ui": {
                        "geolocation": false,
                        "notifications": false
                    }
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        # javascript_optimizer: if default_content_setting_values is enabled.
        #   automatically disable JavaScript optimizers on unfamiliar sites
        Merge-Hashtable $BravePreferences ('{
            "safebrowsing": {
                "javascript_optimizer_blocked_for_unfamiliar_sites": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Tor windows
        #---------------
        Merge-Hashtable $BraveLocalState ('{
            "tor": {
                "tor_disabled": true
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Data collection
        #---------------
        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "p3a": {
                    "enabled": false // product analytics
                },
                "stats": {
                    "reporting_enabled": false // daily ping
                }
            },
            "user_experience_metrics": {
                "reporting_enabled": false // diagnostic reports
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "new_tab_page": {
                    "sponsored_images": {
                        "survey_panelist": false // Brave surveys links
                    }
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion privacy

        #------------------------------------
        ## Web3
        #------------------------------------
        #region web3

        ### Wallet
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "wallet": {
                    // default wallet\ extensions (Brave Wallet fallback): 3 | Brave Wallet: 4 | extensions (no fallback): 1
                    "default_cardano_wallet": 1,
                    "default_solana_wallet": 1,
                    "default_wallet2": 1, // Ethereum
                    "nft_discovery_enabled": false,
                    "private_windows_enabled": false
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Web3 domains
        #---------------
        Merge-Hashtable $BraveLocalState ('{
            "brave": { // resolve method\ ask: 0 | off: 1 | on: 3
                "unstoppable_domains": {
                    "resolve_method": 1
                },
                "ens": { // Ethereum Name Service
                    "resolve_method": 1
                },
                "sns": { // Solana Name Service
                    "resolve_method": 1
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion web3

        #------------------------------------
        ## Leo
        #------------------------------------
        #region leo

        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "sidebar": {
                    "sidebar_items": [
                        {
                            "built_in_item_type": 7 // show Leo icon
                        }
                    ]
                },
                "ai_chat": {
                    "auto_generate_questions": false, // suggested prompts
                    "context_menu_enabled": false,
                    "storage_enabled": false, // history
                    "tab_organization_enabled": false // tab Focus Mode
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Customize Leo's responses and memories
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "ai_chat": {
                    "user_customization_enabled": false, // about you
                    "user_memory_enabled": false
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion leo

        #------------------------------------
        ## Search engine
        #------------------------------------
        #region search

        Merge-Hashtable $BravePreferences ('{
            "search": {
                "suggest_enabled": false // show search suggestions
            },
            "brave": {
                "web_discovery_enabled": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion search

        #------------------------------------
        ## Extensions
        #------------------------------------
        #region extensions

        Merge-Hashtable $BravePreferences ('{
            "signin": {
                "allowed": false // google login
            },
            "media_router": {
                "enable_media_router": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "widevine_opted_in": false // needed for some online stream content
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion extensions

        #------------------------------------
        ## Autofill and passwords
        #------------------------------------
        #region autofill

        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "autofill_private_windows": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Password Manager
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "credentials_enable_autosignin": false,
            "credentials_enable_service": false, // offer to save passwords and passkeys
            "credentials_enable_automatic_passkey_upgrades": false // auto create passkey
        }' | ConvertFrom-Json -AsHashtable)

        ### Payment methods
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "autofill": {
                "credit_card_enabled": false, // save and fill payment methods
                "payment_methods_mandatory_reauth": false, // verify it is you (always use fingerprint, face, or other screen lock)
                "payment_cvc_storage": false, // save security codes
                "payment_card_benefits": false
            },
            "payments": {
                "can_make_payment_enabled": false // allow sites to check if you have payment methods saved
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Addresses and more
        #---------------
        Merge-Hashtable $BravePreferences ('{
            "autofill": {
                "profile_enabled": false // save and fill addresses
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion autofill

        #------------------------------------
        ## Languages
        #------------------------------------
        #region languages

        Merge-Hashtable $BravePreferences ('{
            "translate": {
                "enabled": false // use Brave Translate (if disabled, translate still available with right click)
            },
            "browser": {
                "enable_spellchecking": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion languages

        #------------------------------------
        ## Downloads
        #------------------------------------
        #region downloads

        Merge-Hashtable $BravePreferences ('{
            "download": {
                "prompt_for_download": true // ask where to save each file before downloading
            },
            "download_bubble": {
                "partial_view_enabled": true // show downloads when done
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion downloads

        #------------------------------------
        ## Accessibility
        #------------------------------------
        #region accessibility

        Merge-Hashtable $BravePreferences ('{
            "settings": {
                "a11y": {
                    "caretbrowsing": { // navigate pages with a text cursor
                        "enabled": false
                    },
                    "focus_highlight": false
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BraveLocalState ('{
            "settings": {
                "a11y": {
                    "overscroll_history_navigation": true // swipe between pages
                },
                "toast": {
                    "alert_level": 0 // copied to clipboard confirmations\ on: 0 | off: 1
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion accessibility

        #------------------------------------
        ## System
        #------------------------------------
        #region system

        Merge-Hashtable $BraveLocalState ('{
            "background_mode": {
                "enabled": false
            },
            "hardware_acceleration_mode": {
                "enabled": true
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BravePreferences ('{
            "brave": {
                "enable_closing_last_tab": true,
                "enable_window_closing_confirm": true,
                "show_fullscreen_reminder": false
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### Memory & Power
        #---------------
        Merge-Hashtable $BraveLocalState ('{
            "performance_tuning": {
                "battery_saver_mode": { // energy saver
                    "state": 3 // on: 1 (battery is at 20% or lower), 2 (computer is unplugged), 3 (always) (no GUI toggle) | off: 0
                },
                "high_efficiency_mode": { // memory saver
                    "aggressiveness": 1, // moderate: 0 | balanced: 1 | maximum: 2
                    "state": 0 // on: 2 | off: 0
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        ### VPN
        #---------------
        $WireGuardActive = 'true'

        Merge-Hashtable $BraveLocalState ("{
            ""brave"": {
                ""brave_vpn"": {
                    ""wireguard_enabled"": $WireGuardActive
                }
            }
        }" | ConvertFrom-Json -AsHashtable)

        $BraveVpnReg = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\BraveSoftware\Vpn\BraveVpnWireguardService'
            Entries = @(
                @{
                    Name  = 'EnableTrayIcon'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'WireGuardActive'
                    Value = $WireGuardActive -eq 'true' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }
        Set-RegistryEntry -InputObject $BraveVpnReg -Verbose:$false

        #endregion system

        #------------------------------------
        ## Miscellaneous
        #------------------------------------
        #region misc

        Merge-Hashtable $BravePreferences ('{
            "browser": {
                "has_seen_welcome_page": true
            },
            "brave": {
                "brave_search_conversion": {
                    "dismissed": true // search widget in new tabs popup: Enable search suggestions
                },
                "shields": {
                    "advanced_view_enabled": true
                },
                "sidebar": {
                    "hidden_built_in_items": [
                        1, // Brave Talk
                        2, // Brave Wallet
                        3, // Bookmarks
                        4  // Reading List
                    ],
                    "item_added_feedback_bubble_shown_count": 3, // overlay tip: added, Right-click to remove\ on: 0 | off: 3
                    "side_panel_width": 500 // default and minimum: 320
                },
                "tabs": {
                    "vertical_tabs_expanded_width": 220 // default: 220 | min: 114 | max: 482
                },
                "ai_chat": {
                    "user_dismissed_premium_prompt": true,
                    "user_dismissed_storage_notice": true, // privacy/storage notice popup
                    "toolbar_button_opens_full_page": false
                }
            },
            "in_product_help": { // disable overlay tip: Inactive tabs get a new look (and probably more)
                "policy_last_heavyweight_promo_time": "99999999999999999"
            },
            "omnibox": {
                "shown_count_history_scope_promo": 3 // tip: Type @history to search your browsing history\ on: 0 | off: 3
            },
            "tab_search": {
                "recently_closed_expanded": true
            }
        }' | ConvertFrom-Json -AsHashtable)

        Merge-Hashtable $BraveLocalState ('{
            "brave": {
                "dont_ask_for_crash_reporting": true,
                "onboarding": {
                    "last_shields_icon_highlighted_time": "1" // Shields onboarding highlight\ on: 0 | off: non-0
                }
            }
        }' | ConvertFrom-Json -AsHashtable)

        #endregion misc

        $BraveLocalState
        $BravePreferences
    }
}
