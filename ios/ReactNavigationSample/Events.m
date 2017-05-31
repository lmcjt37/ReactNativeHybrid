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

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"LogEvent",@"LogSuccess"];
}

- (void)logEvent:(NSString *)event
{
    [self sendEventWithName:@"LogEvent" body:@{@"log": event}];
}

- (void)logSuccess:(NSDictionary *)response
{
    [self sendEventWithName:@"LogSuccess" body:@{@"response": response}];
}

@end
