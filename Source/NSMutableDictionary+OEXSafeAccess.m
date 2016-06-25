//
//  NSMutableDictionary+OEXSafeAccess.m
//  edXVideoLocker
//
//  Created by Akiva Leffert on 12/8/14.
//  Copyright (c) 2014 edX. All rights reserved.
//

#import "NSMutableDictionary+OEXSafeAccess.h"

#import "edX-Swift.h"
#import "Logger+OEXObjC.h"

@implementation NSMutableDictionary (OEXSafeAccess)

- (void)setObjectOrNil:(id)object forKey:(id <NSCopying>)key {
    if(object && key) {
        self[key] = object;
    }
}

- (void)safeSetObject:(id)object forKey:(id <NSCopying>)key {
    [self setObjectOrNil:object forKey:key];
    if(!object) {
#if DEBUG
        NSAssert(NO, @"Expecting object for key: %@", key);
#else
        OEXLogError(@"FOUNDATION", @"Expecting object for key: %@", key);
#endif
    }
}

@end
