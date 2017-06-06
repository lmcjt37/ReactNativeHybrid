//
//  EventEmitterBridge.m
//  ReactNavigationSample
//
//  Created by Luke Taylor on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(EventEmitter, RCTEventEmitter)

RCT_EXTERN_METHOD(supportedEvents)

@end
