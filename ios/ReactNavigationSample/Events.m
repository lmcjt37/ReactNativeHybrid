//
//  Events.m
//  ReactNavigationSample
//
//  Created by Luke Taylor on 5/26/17.
//  Copyright © 2017 Luke Taylor. All rights reserved.
//

#import "Events.h"

@implementation Events

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"LogEvent", @"LogSuccess"];
}

- (void)startObserving {
  for (NSString *event in [self supportedEvents]) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logEventInternal:)
                                                 name:event
                                               object:nil];
  }
}

- (void)stopObserving {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Emits event to Javascript
- (void)logEventInternal:(NSNotification *)notification
{
  [self sendEventWithName:notification.name
                     body:notification.userInfo];
}

// Consumes our events
+ (void)logEventWithName:(NSString *)name withPayload:(NSDictionary *)payload
{
  [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                      object:self
                                                    userInfo:payload];
}


@end
