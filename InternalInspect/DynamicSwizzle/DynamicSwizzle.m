//
//  DynamicSwizzle.h
//  test
//
//  Created by Sebastian Kassai on 20/03/2025.
//

@import Foundation;
#import "DynamicSwizzle.h"

@implementation DynamicSwizzle

+ (BOOL)swizzle:(NSString*)className :(NSString*)originalSelectorName :(SEL)swizzleSelector {
    // Dynamically find the UIView class
    Class targetClass = NSClassFromString(className);
    if (targetClass) {
        //        Class superClass = [targetClass superclass];
        Class superClass = class_getSuperclass(targetClass);
        if ([superClass instancesRespondToSelector:NSSelectorFromString(originalSelectorName)]) {
            NSLog(@"[%@]: super (%@) already responds to SEL %@ - skipping...", className, [superClass description], originalSelectorName);
            return NO;
        }
        
        // Define the original and swizzled selectors
        SEL originalSelector = NSSelectorFromString(originalSelectorName);
        
        // Get the original method
        Method originalMethod = class_getInstanceMethod(targetClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzleSelector);
        
        // Ensure both methods are found
        if (originalMethod && swizzledMethod) {
            // Attempt to add the swizzled method as the original method
            BOOL didAddMethod = class_addMethod(targetClass,
                                                swizzleSelector,
                                                method_getImplementation(originalMethod),
                                                method_getTypeEncoding(originalMethod));
            
            if (didAddMethod) {
                // If successful, replace the swizzled method with the original method
                class_replaceMethod(targetClass,
                                    originalSelector,
                                    method_getImplementation(swizzledMethod),
                                    method_getTypeEncoding(swizzledMethod));
            } else {
                // If the method already exists, exchange their implementations
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        } else {
            NSLog(@"Error: Original or swizzled method not found.");
            return NO;
        }
    } else {
        NSLog(@"Error: Class '%@' not found.", className);
        return NO;
    }
    
    NSLog(@"Successfully swizzled [%@ %@]", className, originalSelectorName);
    return YES;
}

NSMutableSet *xxx_boolForKey_loggedStrings;

+ (void)load {
    //    return;
    NSLog(@"[DynamicSwizzle]: load()");
    
    if (xxx_boolForKey_loggedStrings == NULL) {
        xxx_boolForKey_loggedStrings = [NSMutableSet set];
    }
    
    [self swizzle:@"NSData":@"writeToURL:options:error:":@selector(xxx_writeToURL:options:error:)];
    [self swizzle:@"FFConfiguration":@"fileURLForLevelIndex:pathIndex:":@selector(xxx_fileURLForLevelIndex::)];

    
//    [self swizzle:@"NSUserDefaults":@"boolForKey:":@selector(xxx_boolForKey:)];
//    [self swizzle:@"NSURL":@"URLByAppendingPathComponent:":@selector(xxx_URLByAppendingPathComponent:)];
}

- (NSURL*)xxx_fileURLForLevelIndex:(int)index :(int)pathIndex {
    NSURL* result = [self xxx_fileURLForLevelIndex:index:pathIndex];
//    NSURL* result = [NSURL URLWithString:@"file://private/var/preferences/FeatureFlags/Global.plist"];
//    NSURL* result = [NSURL URLWithString:@"file:///Users/szebi/Desktop/Global.plist"];
    NSLog(@"[fileURLForLevelIndex]: url: %@  index: %d  pathIndex: %d", result, index, pathIndex);
    return result;
}

- (BOOL)xxx_writeToURL:(NSURL *)url
           options:(NSDataWritingOptions)writeOptionsMask
             error:(NSError * _Nullable *)errorPtr {
    
    NSLog(@"[writeToURL]: url: %@", url);
    
    return [self xxx_writeToURL:url options:writeOptionsMask error:errorPtr];
}

- (NSURL*)xxx_URLByAppendingPathComponent:(NSString*)path {
    NSURL* result = [self xxx_URLByAppendingPathComponent:path];
    NSLog(@"[URLByAppendingPathComponent:]: result: \"%@\"", result);
    return result;
}

- (BOOL)xxx_boolForKey:(NSString*)key {
    BOOL result = [self xxx_boolForKey:key];
    
//    @synchronized (loggedStrings) {
        if (![xxx_boolForKey_loggedStrings containsObject:key]) {
            NSLog(@"[boolForKey:] key: %@ value: %@", key, result ? @"YES" : @"NO");
            [xxx_boolForKey_loggedStrings addObject:key];
        }
//    }
    
    
    return result;
}

- (BOOL)xxx_runtimeInternalStateContains:(int)flag {
//    NSLog(@"[runtimeInternalStateContains:] flag: 0x%x", flag);
    
    BOOL actualValue = [self xxx_runtimeInternalStateContains:flag];
    
//    if (flag == 0x40)    return actualValue;
//    if (flag == 0x4000)  return actualValue;
    if (flag == 0x20000) return actualValue;
    
    if (flag == 0x10) return actualValue; // ASAN
    
//    if (flag == 0x2) return YES;
//    if (flag == 0x4) return YES;
//    if (flag == 0x6) return YES;
    return YES;
}

- (void)xxx_nop {
    return;
}

- (BOOL)xxx_isHidden {
    return NO;
}

- (BOOL)xxx_ReturnYes {
    return YES;
}

- (BOOL)xxx_ReturnNo {
    return NO;
}

- (void)xxx_setWithArgYes:(BOOL)arg {
    arg = YES;
    [self xxx_setWithArgYes:arg];
}

- (void)xxx_setWithArgNo:(BOOL)arg {
    arg = NO;
    [self xxx_setWithArgNo:arg];
}


- (void)xxx_setHidden:(BOOL)hidden {
    BOOL setHidden_value_override = NO;
    
    // Custom behavior before calling the original method
//    NSLog(@"[%@ setHidden:] called with %@, overriding to %@", self.className, hidden ? @"YES" : @"NO", setHidden_value_override ? @"YES" : @"NO");
    
    hidden = setHidden_value_override;

    // Call the original setHidden: method
    [self xxx_setHidden:hidden];
}

- (void)xxx_setEnabled:(BOOL)enabled {
    BOOL target = YES;
    
    // Custom behavior before calling the original method
//    NSLog(@"[%@ setHidden:] called with %@, overriding to %@", self.className, hidden ? @"YES" : @"NO", setHidden_value_override ? @"YES" : @"NO");
    
    enabled = target;

    // Call the original setHidden: method
    [self xxx_setEnabled:target];
}

int open_target(const char *path, int oflag, ...) {
    int result = open(path, oflag);
    printf("[open()]: path: \"%s\" result: %d\n", path, result);
    
//    @autoreleasepool {
//        NSArray *symbols = [NSThread callStackSymbols];
//        NSLog(@"Call Stack: %@", symbols);
//    }
    
    //NSLog(@"callStack: %@", callStack);
    
    return result;
}

#define DYLD_INTERPOSE(new_func, old_func) \
    __attribute__((used)) static struct { const void *replacement; const void *original; } _interpose_##old_func \
    __attribute__((section("__DATA,__interpose"))) = { (const void *)new_func, (const void *)old_func };

__attribute__((constructor)) static void ctor(void)
{
    printf("Dylib constructor called!\n");
    
//    DYLD_INTERPOSE(open_target, open);
}

@end
