import Foundation

@MainActor
let packetGroups = [
    
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
        Packet("MGCopyAnswer", "ReleaseType", isStringArg: true),
        Packet("MGCopyAnswer", "ProductType", isStringArg: true),
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
