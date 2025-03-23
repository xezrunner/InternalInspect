//
//  FFtest.m
//  InternalTest
//
//  Created by Sebastian Kassai on 23/03/2025.
//


#import "FeatureFlagsBridge.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FeatureFlagState

@synthesize attributes;
@synthesize domain;
@synthesize feature;
@synthesize value;
@synthesize buildVersion;
@synthesize phase;
@synthesize disclosureRequired;

- (BOOL)isEnabled {
    return self.value == 1; // TODO: is this actually right?
}

@end

@implementation FeatureFlagsBridge

NSObject* FFConfiguration_shared;

+ (FeatureFlagState*)getValue:(NSString*)domain :(NSString*)feature {
    SEL stateSel = NSSelectorFromString(@"stateForFeature:domain:");
    NSObject* resultObj = [FFConfiguration_shared performSelector: stateSel withObject:feature withObject:domain];
    
    FeatureFlagState* result = [FeatureFlagState alloc];
    if (resultObj) {
        result.attributes         = [resultObj  valueForKey:@"_attributes"];
        result.domain             = [resultObj  valueForKey:@"_domain"];
        result.feature            = [resultObj  valueForKey:@"_feature"];
        result.value              = [[resultObj valueForKey:@"_value"] longLongValue];
        result.buildVersion       = [resultObj  valueForKey:@"_buildVersion"];
        result.phase              = [resultObj  valueForKey:@"_phase"];
        result.disclosureRequired = [resultObj  valueForKey:@"_disclosurerequired"];
    } else {
        result.isNotDeclared = YES; // Mark non-declared FFs
        
        result.domain = domain;
        result.feature = feature;
        result.value = 0;
    }
    
    return result;
}

+ (NSSet*)getDomains {
    SEL domainsSel = NSSelectorFromString(@"domains");
    return [FFConfiguration_shared performSelector:domainsSel];
}

+ (NSSet*)getFeaturesForDomain:(NSString*)domain {
    SEL sel = NSSelectorFromString(@"featuresForDomain:");
    return [FFConfiguration_shared performSelector:sel withObject:domain];
}

+ (void)load {
    NSLog(@"[FeatureFlagsBridge] load()!");
    
    void* handle = dlopen("/System/Library/PrivateFrameworks/FeatureFlagsSupport.framework/FeatureFlagsSupport", RTLD_NOW);
    NSLog(@"[FeatureFlagsBridge] handle to FFSupport framework: %p", handle);
    
    if (handle == NULL) {
        NSLog(@"[FeatureFlagsBridge] failed to load framework handle - feature flags will not be supported.");
        return;
    }
    
    Class c = NSClassFromString(@"FFConfiguration");
    SEL sharedSel = NSSelectorFromString(@"shared");
    NSObject* obj = FFConfiguration_shared = [c performSelector: sharedSel];
    
    NSLog(@"[FeatureFlagsBridge] shared FFConfiguration obj: %@", obj);
    
    SEL checkSel = NSSelectorFromString(@"stateForFeature:domain:");
    NSObject* result = [obj performSelector:checkSel withObject:@"vision_os_keyboard_should_display_writing_tools_candidates_options" withObject:@"UIKit"];
    NSLog(@"result: %@", result ? @"YES" : @"NO");
    
#if false && !TARGET_OS_MAC
    
    
//    SEL domainsSel = NSSelectorFromString(@"domains");
//    NSString* domains = [obj performSelector: domainsSel];
//    NSLog(@"domains: %@", domains);
    
//    SEL enableSel = NSSelectorFromString(@"enableFeature:domain:level:");
//    [obj performSelector:enableSel withObject:@"Test" withObject:@"whatever"];
    
//    SEL lallSel = NSSelectorFromString(@"loadAllLevelsForDomain:");
//    NSObject* lall = [obj performSelector:lallSel withObject:@"Siri"];
    
#if !TARGET_OS_MACCATALYST
    SEL enableSel = NSSelectorFromString(@"enableFeature:domain:level:");
    
    NSString* a1 = @"patient_siri";
    NSString* a2 = @"Siri";
    NSNumber* a3 = [NSNumber numberWithInt:0x4];
    
    typedef NSObject* (*send_type)(NSObject*, SEL, NSString*, NSString*, int);
    send_type func = (send_type)objc_msgSend;
    NSObject* result = func(obj, sel_getUid("disableFeature:domain:levelIndex:"), a1, a2, 0x7);
    
    SEL commitSel = NSSelectorFromString(@"commitUpdates:");
    [obj performSelector:commitSel withObject:result];
#endif
    
//    SEL checkSel = NSSelectorFromString(@"stateForFeature:domain:level");
    
//    NSObject* retVal;
    
//    SEL ffdSel = NSSelectorFromString(@"featuresForDomain:");
//    NSObject* features = [obj performSelector:ffdSel withObject:@"Siri"];
//    NSLog(@"features: %@", features);
#endif
}

@end

NS_ASSUME_NONNULL_END
