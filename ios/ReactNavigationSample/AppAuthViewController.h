//
//  AppAuthViewController.h
//  ReactNavigationSample
//
//  Created by Luke Taylor on 5/12/17.
//  Copyright © 2017 Luke Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OIDAuthState;
@class OIDServiceConfiguration;

@interface AppAuthViewController : UIViewController

@property(nonatomic, readonly, nullable) OIDAuthState *authState;

@end
