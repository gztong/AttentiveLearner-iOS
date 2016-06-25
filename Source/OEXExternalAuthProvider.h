//
//  OEXExternalAuthProvider.h
//  edXVideoLocker
//
//  Created by Akiva Leffert on 3/24/15.
//  Copyright (c) 2015-2016 edX. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class OEXRegisteringUserDetails;

@protocol OEXExternalAuthProvider <NSObject>

/// Name used in the UI
@property (readonly, nonatomic) NSString* displayName;

/// Name used when communicating with the server
@property (readonly, nonatomic) NSString* backendName;

- (UIButton*)freshAuthButton;

- (void)authorizeServiceFromController:(UIViewController *)controller requestingUserDetails:(BOOL)loadUserDetails withCompletion:(void (^)(NSString *, OEXRegisteringUserDetails *, NSError *))completion;

@end

NS_ASSUME_NONNULL_END