//
//  Alert.m
//  ReactNavigationSample
//
//  Created by Luke Taylor on 5/4/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alert.h"

@implementation Alert

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getAlert:(NSString *)message) {
  
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Example alert" message:message preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
  
  [alert addAction:defaultAction];
  
  [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
  
};

@end
