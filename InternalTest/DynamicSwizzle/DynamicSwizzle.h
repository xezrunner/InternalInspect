//
//  DynamicSwizzle.h
//  test
//
//  Created by Sebastian Kassai on 20/03/2025.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dlfcn.h>


@interface DynamicSwizzle : NSObject

+ (BOOL)swizzle:(NSString*)className :(NSString*)originalSelectorName :(SEL)swizzleSelector;

+ (void)init_swizzles;

@end
