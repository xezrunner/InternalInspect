import Foundation

@MainActor
let packetGroups = [
    PacketGroup(handlePath: "/usr/lib/system/libsystem_eligibility.dylib", [
        PacketDefinition(packetType: .PACKET_ELIGIBILITY, "OS_ELIGIBILITY_DOMAIN_GREYMATTER"),
        PacketDefinition(packetType: .PACKET_ELIGIBILITY, "INVALID"),
    ]),
    
    PacketGroup(handlePath: "/usr/lib/system/libsystem_featureflags.dylib", [
        PacketDefinition("_os_feature_enabled_impl", "AppKit", "Glade"),
        PacketDefinition("_os_feature_enabled_impl", "UIKit", "Pegasus"),
        PacketDefinition("_os_feature_enabled_impl", "UIKit", "keyboard_oop"),
        PacketDefinition("_os_feature_enabled_impl", "UIKit", "global_edge_swipe_touches_ios"),
        PacketDefinition("_os_feature_enabled_impl", "UIKit", "swift_c2"),
        
        
        PacketDefinition("_os_feature_enabled_impl", "Oneness", "App"),
        PacketDefinition("_os_feature_enabled_impl", "Oneness", "Shell"),
        
        PacketDefinition("_os_feature_enabled_impl", "SpotlightUI", "UnifiedKeyboardBackground"),
        
        PacketDefinition("_os_feature_enabled_impl", "Mail", "CatchUp"),
        
        PacketDefinition("_os_feature_enabled_impl", "Photos", "PhotoPickerUsageInfo"),
        
        PacketDefinition("_os_feature_enabled_impl", "SettingsApp", "SettingsUndo"),
        
        PacketDefinition("_os_feature_enabled_impl", "PreferencesFramework", "multiline_cells_enabled"),
        PacketDefinition("_os_feature_enabled_impl", "PreferencesFramework", "modern_layout_enabled"),
        PacketDefinition("_os_feature_enabled_impl", "PreferencesFramework", "inset_table_style_enabled"),
        
        PacketDefinition("_os_feature_enabled_impl", "PerfPowerServices", "battery_health_details"),
        PacketDefinition("_os_feature_enabled_impl", "StorageManagement", "StorageUIV2"),
        
        PacketDefinition("_os_feature_enabled_impl", "ControlCenter", "NewControls"),
        
        PacketDefinition("_os_feature_enabled_impl", "Ensemble", "SystemUIScene"),
        
        PacketDefinition("_os_feature_enabled_impl", "DeviceOSExpert", "SemanticSearch"), // 0
        PacketDefinition("_os_feature_enabled_impl", "Siri", "sae_override"), // 0
        PacketDefinition("_os_feature_enabled_impl", "Siri", "force_uod_enabled_for_device"), // 0
        
        PacketDefinition("_os_feature_enabled_impl", "CoreVideo", "UseIOSurfaceAttachmentsDirectly"), // 0
        
        PacketDefinition("_os_feature_enabled_impl", "NotificationsUI", "ReactiveList"), // 0
        PacketDefinition("_os_feature_enabled_impl", "BulletinBoard", "BulletinBoardRefactor"), // 0
        
        PacketDefinition("_os_feature_enabled_impl", "Messages", "steefm"), // 0
        PacketDefinition("_os_feature_enabled_impl", "Messages", "mdv"), // 0

        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "AutobahnQuickSwitchTransition"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "SwiftUITimeAnimation"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "SooP"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "SlipSwitch"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "ShellSceneKit"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "AHP"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "ExpansionBoard"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Oneness"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "OnenessHomeScreenEditing"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "OnenessHomeScreenOnEmbedded"), // 0
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "AsynchronousIconImageLoading"), // 0
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Twoness"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "FlyingScotsman"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Dewey"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Autobahn"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Maglev"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Monaco"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "WooP"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "SystemUIScene"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "TraitsArbiterWallpaperTokyoDrift"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Meatballs"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "support_scene_reconnect"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "StatusBarReusePool"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "Domino"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "SuperDomino"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "FlagOnThePlay"),
        PacketDefinition("_os_feature_enabled_impl", "SpringBoard", "FlagMeDown"),
    ]),
    
    PacketGroup(handlePath: "/usr/lib/system/libsystem_darwin.dylib", [
        PacketDefinition("os_variant_has_internal_diagnostics"),
        PacketDefinition("os_variant_has_internal_content"),
        PacketDefinition("os_variant_has_internal_ui"),
        PacketDefinition("os_variant_has_factory_content"),
        PacketDefinition("os_variant_allows_internal_security_policies"),
        PacketDefinition("os_variant_allows_security_research"),
        PacketDefinition("os_variant_is_darwinos"),
        PacketDefinition("os_variant_is_recovery"),
        PacketDefinition("os_variant_uses_ephemeral_storage"),
    ]),
    
    PacketGroup(handlePath: "/usr/lib/libMobileGestalt.dylib", [
        PacketDefinition("MobileGestalt_get_appleInternalInstallCapability"),
        PacketDefinition("MobileGestalt_get_internalBuild"),
        PacketDefinition("MobileGestalt_get_hasInternalSettingsBundle"),
        PacketDefinition("MobileGestalt_get_isEmulatedDevice"),
        PacketDefinition("MobileGestalt_get_isVirtualDevice"),
        PacketDefinition("MobileGestalt_get_isSimulator"),
        PacketDefinition("MobileGestalt_get_storeDemoMode"),
        PacketDefinition("MGGetBoolAnswer", "apple-internal-install"),
        PacketDefinition("MGGetBoolAnswer", "IsSimulator"),
        PacketDefinition("MGGetBoolAnswer", "ulMliLomP737aAOJ/w/evA"),
        PacketDefinition("MGGetBoolAnswer", "HasInternalSettingsBundle"),
        PacketDefinition("MGGetBoolAnswer", "SBCanForceDebuggingInfo"),
        PacketDefinition("MGGetBoolAnswer", "SBAllowSensitiveUI"),
        PacketDefinition("MGCopyAnswer", "ReleaseType", isStringReturnType: true),
        PacketDefinition("MGCopyAnswer", "ProductType", isStringReturnType: true),
    ]),
    
    PacketGroup(handlePath: "/System/Library/PrivateFrameworks/BaseBoard.framework/BaseBoard", [
        PacketDefinition("_BSIsInternalInstall"),
        PacketDefinition("_BSHasInternalSettings"),
        PacketDefinition(packetType: PacketType.PACKET_OBJC, "-[BSPlatform isInternalInstall]"),
        PacketDefinition(packetType: PacketType.PACKET_OBJC, "-[BSPlatform isInternalBuild]"),
        PacketDefinition(packetType: PacketType.PACKET_OBJC, "-[BSPlatform isCarrierBuild]"),
        PacketDefinition(packetType: PacketType.PACKET_OBJC, "-[BSPlatform isInternalOrCarrierBuild]"),
        PacketDefinition(packetType: PacketType.PACKET_OBJC, "-[BSPlatform test]"),
    ])
    
]
