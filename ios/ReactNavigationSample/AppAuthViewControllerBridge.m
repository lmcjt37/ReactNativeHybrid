//
//  AppAuthViewControllerBridge.m
//  ReactNavigationSample
//
//  Created by Luke Taylor on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AppAuth/AppAuth.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(AppAuthViewController, UIViewController)

// handles issuer token and user info calling event emitter to pass data to react native
RCT_EXTERN_METHOD(authorise:(RCTResponseSenderBlock *)callback)

// returns boolean
RCT_EXTERN_METHOD(isAuthorised:(RCTResponseSenderBlock *)callback)

// clears authState (TODO:: emit event to trigger logout/ use callback)
RCT_EXTERN_METHOD(logout:(RCTResponseSenderBlock *)callback)

@end
