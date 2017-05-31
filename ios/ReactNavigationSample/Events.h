//
//  Events.h
//  ReactNavigationSample
//
//  Created by Luke Taylor on 5/26/17.
//  Copyright © 2017 Luke Taylor. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface Events : RCTEventEmitter <RCTBridgeModule>

- (void)logEvent:(NSString *)event;

- (void)logSuccess:(NSDictionary *)response;

@end
