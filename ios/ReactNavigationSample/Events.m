//
//  Events.m
//  ReactNavigationSample
//
//  Created by Luke Taylor on 5/26/17.
//  Copyright © 2017 Luke Taylor. All rights reserved.
//

#import "Events.h"
#import "AppDelegate.h"

@implementation Events
{
  bool hasListeners;
}

RCT_EXPORT_MODULE();

@synthesize bridge;

- (void)startObserving {
    hasListeners = YES;
}

- (void)stopObserving {
    hasListeners = NO;
}

- (void)setBridge
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
    self.bridge = delegate.bridge;
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"LogEvent",@"LogSuccess"];
}

- (void)logEvent:(NSString *)event
{
  if (hasListeners) {
    [self setBridge];
    [self sendEventWithName:@"LogEvent" body:@{@"log": event}];
  }
}

- (void)logSuccess:(NSDictionary *)response
{
  if (hasListeners) {
    [self setBridge];
    [self sendEventWithName:@"LogSuccess" body:@{@"response": response}];
  }
}

@end
