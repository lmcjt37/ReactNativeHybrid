//
//  AppAuthViewControllerBridge.m
//  ReactNavigationSample
//
//  Created by Luke Taylor on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>
#import <AppAuth/AppAuth.h>

@interface RCT_EXTERN_MODULE(AppAuthViewController, UIViewController)

RCT_EXTERN_METHOD(authorise:(id nullable) callback(RCTResponseSenderBlock *)callback)

RCT_EXTERN_METHOD(isAuthorised:(id nullable) callback(RCTResponseSenderBlock *)callback)

@end
