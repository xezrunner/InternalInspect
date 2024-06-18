import Foundation

@MainActor
let packetGroups = [
    PacketGroup(handlePath: "/usr/lib/system/libsystem_eligibility.dylib", [
        Packet("eligibility", "OS_ELIGIBILITY_DOMAIN_GREYMATTER", packetType: .PACKET_ELIGIBILITY),
    ]),
    
    PacketGroup(handlePath: "/usr/lib/system/libsystem_featureflags.dylib", [
        Packet("_os_feature_enabled_impl", "AppKit", "Glade"),
        Packet("_os_feature_enabled_impl", "UIKit", "Pegasus"),
        Packet("_os_feature_enabled_impl", "UIKit", "keyboard_oop"),
        Packet("_os_feature_enabled_impl", "UIKit", "global_edge_swipe_touches_ios"),
        Packet("_os_feature_enabled_impl", "UIKit", "swift_c2"),
        
        
        Packet("_os_feature_enabled_impl", "Oneness", "App"),
        Packet("_os_feature_enabled_impl", "Oneness", "Shell"),
        
        Packet("_os_feature_enabled_impl", "SpotlightUI", "UnifiedKeyboardBackground"),
        
        Packet("_os_feature_enabled_impl", "Mail", "CatchUp"),
        
        Packet("_os_feature_enabled_impl", "Photos", "PhotoPickerUsageInfo"),
        
        Packet("_os_feature_enabled_impl", "SettingsApp", "SettingsUndo"),
        
        Packet("_os_feature_enabled_impl", "PreferencesFramework", "multiline_cells_enabled"),
        Packet("_os_feature_enabled_impl", "PreferencesFramework", "modern_layout_enabled"),
        Packet("_os_feature_enabled_impl", "PreferencesFramework", "inset_table_style_enabled"),
        
        Packet("_os_feature_enabled_impl", "PerfPowerServices", "battery_health_details"),
        Packet("_os_feature_enabled_impl", "StorageManagement", "StorageUIV2"),
        
        Packet("_os_feature_enabled_impl", "ControlCenter", "NewControls"),
        
        Packet("_os_feature_enabled_impl", "Ensemble", "SystemUIScene"),
        
        Packet("_os_feature_enabled_impl", "DeviceOSExpert", "SemanticSearch"), // 0
        Packet("_os_feature_enabled_impl", "Siri", "sae_override"), // 0
        Packet("_os_feature_enabled_impl", "Siri", "force_uod_enabled_for_device"), // 0
        
        Packet("_os_feature_enabled_impl", "CoreVideo", "UseIOSurfaceAttachmentsDirectly"), // 0
        
        Packet("_os_feature_enabled_impl", "NotificationsUI", "ReactiveList"), // 0
        Packet("_os_feature_enabled_impl", "BulletinBoard", "BulletinBoardRefactor"), // 0
        
        Packet("_os_feature_enabled_impl", "Messages", "steefm"), // 0
        Packet("_os_feature_enabled_impl", "Messages", "mdv"), // 0

        Packet("_os_feature_enabled_impl", "SpringBoard", "AutobahnQuickSwitchTransition"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "SwiftUITimeAnimation"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "SooP"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "SlipSwitch"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "ShellSceneKit"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "AHP"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "ExpansionBoard"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "Oneness"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "OnenessHomeScreenEditing"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "OnenessHomeScreenOnEmbedded"), // 0
        Packet("_os_feature_enabled_impl", "SpringBoard", "AsynchronousIconImageLoading"), // 0
        Packet("_os_feature_enabled_impl", "SpringBoard", "Twoness"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "FlyingScotsman"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "Dewey"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "Autobahn"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "Maglev"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "Monaco"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "WooP"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "SystemUIScene"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "TraitsArbiterWallpaperTokyoDrift"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "Meatballs"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "support_scene_reconnect"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "StatusBarReusePool"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "Domino"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "SuperDomino"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "FlagOnThePlay"),
        Packet("_os_feature_enabled_impl", "SpringBoard", "FlagMeDown"),
    ]),
    
    PacketGroup(handlePath: "/usr/lib/system/libsystem_darwin.dylib", [
        Packet("os_variant_has_internal_diagnostics"),
        Packet("os_variant_has_internal_content"),
        Packet("os_variant_has_internal_ui"),
        Packet("os_variant_has_factory_content"),
        Packet("os_variant_allows_internal_security_policies"),
        Packet("os_variant_allows_security_research"),
        Packet("os_variant_is_darwinos"),
        Packet("os_variant_is_recovery"),
        Packet("os_variant_uses_ephemeral_storage"),
    ]),
    
    PacketGroup(handlePath: "/usr/lib/libMobileGestalt.dylib", [
        Packet("MobileGestalt_get_appleInternalInstallCapability"),
        Packet("MobileGestalt_get_internalBuild"),
        Packet("MobileGestalt_get_hasInternalSettingsBundle"),
        Packet("MobileGestalt_get_isEmulatedDevice"),
        Packet("MobileGestalt_get_isVirtualDevice"),
        Packet("MobileGestalt_get_isSimulator"),
        Packet("MobileGestalt_get_storeDemoMode"),
        Packet("MGGetBoolAnswer", "apple-internal-install"),
        Packet("MGGetBoolAnswer", "IsSimulator"),
        Packet("MGGetBoolAnswer", "ulMliLomP737aAOJ/w/evA"),
        Packet("MGGetBoolAnswer", "HasInternalSettingsBundle"),
        Packet("MGGetBoolAnswer", "SBCanForceDebuggingInfo"),
        Packet("MGGetBoolAnswer", "SBAllowSensitiveUI"),
        Packet("MGCopyAnswer", "ReleaseType", isStringReturnType: true),
        Packet("MGCopyAnswer", "ProductType", isStringReturnType: true),
    ]),
    
    PacketGroup(handlePath: "/System/Library/PrivateFrameworks/BaseBoard.framework/BaseBoard", [
        Packet("_BSIsInternalInstall"),
        Packet("_BSHasInternalSettings"),
        Packet("-[BSPlatform isInternalInstall]", packetType: PacketType.PACKET_OBJC),
        Packet("-[BSPlatform isInternalBuild]", packetType: PacketType.PACKET_OBJC),
        Packet("-[BSPlatform isCarrierBuild]", packetType: PacketType.PACKET_OBJC),
        Packet("-[BSPlatform isInternalOrCarrierBuild]", packetType: PacketType.PACKET_OBJC),
        Packet("-[BSPlatform test]", packetType: PacketType.PACKET_OBJC)
    ])
    
]
