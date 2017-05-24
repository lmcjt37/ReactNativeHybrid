/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.

 * @brief AppAuth iOS SDK Example
 * @copyright
 *     Copyright 2015 Google Inc. All Rights Reserved.
 * @copydetails
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 */

#import "AppDelegate.h"

#import "AppAuth.h"
#import "AppAuthExampleViewController.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"ReactNavigationSample"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  UIViewController *rootViewController = [[AppAuthExampleViewController alloc] initWithNibName:nil bundle:nil];

  rootViewController.view = rootView;
  
  window.rootViewController = rootViewController;
  
  _window = window;
  
  [window makeKeyAndVisible];
  
  return YES;
}

/*! @brief Handles inbound URLs. Checks if the URL matches the redirect URI for a pending
 AppAuth authorization request.
 */
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
  // Sends the URL to the current authorization flow (if any) which will process it if it relates to
  // an authorization response.
  NSLog(@"--- flow 1 ---");
  NSLog(@"--- url --- %@", url);
  NSLog(@"--- if --- %d", [_currentAuthorizationFlow resumeAuthorizationFlowWithURL:url]);
  
  if ([_currentAuthorizationFlow resumeAuthorizationFlowWithURL:url]) {
    NSLog(@"--- inside ---");
    _currentAuthorizationFlow = nil;
    return YES;
  }
  NSLog(@"--- flow 2 ---");

  // Your additional URL handling (if any) goes here.

  return NO;
}

/*! @brief Forwards inbound URLs for iOS 8.x and below to @c application:openURL:options:.
 @discussion When you drop support for versions of iOS earlier than 9.0, you can delete this
 method. NB. this implementation doesn't forward the sourceApplication or annotations. If you
 need these, then you may want @c application:openURL:options to call this method instead.
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
  NSLog(@"--- flow 2 ---");
  return [self application:application
                   openURL:url
                   options:@{}];
}



@end
