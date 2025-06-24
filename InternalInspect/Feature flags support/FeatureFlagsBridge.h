//
//  FFtest.h
//  InternalInspect
//
//  Created by Sebastian Kassai on 23/03/2025.
//

@import Foundation;
#import <Foundation/Foundation.h>
#import <objc/message.h>

#include <dlfcn.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeatureFlagState : NSObject

@property                     BOOL isNotSystemDeclared;
@property                     BOOL isAddedByUser;

@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSString     *domain;
@property (nonatomic, strong) NSString     *feature;
@property                     long long    value;
@property (nonatomic, strong) id           buildVersion;
@property (nonatomic, strong) NSString     *phase;
@property (nonatomic, strong) NSString     *disclosureRequired;

- (BOOL)isEnabled;

@end

@interface FeatureFlagsBridge : NSObject

+ (FeatureFlagState*)getValue:(NSString*)domain :(NSString*)feature;

+ (void)setFeature:(BOOL)newState :(NSString*)domain :(NSString*)feature;

+ (NSSet*)getDomains;

+ (NSSet*)getFeaturesForDomain:(NSString*)domain;

@end

NS_ASSUME_NONNULL_END
