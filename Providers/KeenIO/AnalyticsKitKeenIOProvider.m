//
//  AnalyticsKitKeenIOProvider.m
//  AnalyticsKit
//
//  Created by Rob MacEachern on 2014-06-26.
//  Copyright (c) 2014 Two Bit Labs. All rights reserved.
//

#import "AnalyticsKitKeenIOProvider.h"
#import "KeenClient.h"

@implementation AnalyticsKitKeenIOProvider

-(id<AnalyticsKitProvider>)initWithProjectId:(NSString *)projectId
                                    writeKey:(NSString *)writeKey
                                     readKey:(NSString *)readKey
                          geolocationEnabled:(BOOL)geolocationEnabled {
    self = [super init];
    if (self) {
        if (geolocationEnabled) {
            [KeenClient enableGeoLocation];
        } else {
            [KeenClient disableGeoLocation];
        }
        [KeenClient sharedClientWithProjectId:projectId andWriteKey:writeKey andReadKey:readKey];
    }
    return self;
}

-(void)applicationWillEnterForeground {}

-(void)applicationDidEnterBackground {
    UIBackgroundTaskIdentifier taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void) {}];
    
    [[KeenClient sharedClient] uploadWithFinishedBlock:^(void) {
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
    }];
}

-(void)applicationWillTerminate {}

-(void)uncaughtException:(NSException *)exception {
    [[KeenClient sharedClient] addEvent:@{
                                          @"ename" : [exception name] ? [exception name] : @"",
                                          @"reason" : [exception reason] ? [exception reason] : @"",
                                          @"userInfo" : [exception userInfo] ? [exception userInfo] : @""
                                          }
                      toEventCollection:@"Uncaught Exceptions" error:nil];
}

-(void)logScreen:(NSString *)screenName {
    
}

-(void)logEvent:(NSString *)event {
    [self logEvent:event withProperties:@{}];
}

-(void)logEvent:(NSString *)event withProperty:(NSString *)key andValue:(NSString *)value {
    NSParameterAssert(key);
    NSParameterAssert(value);
    key = key ? key : @"";
    value = value ? value : @"";
    [self logEvent:event withProperties:@{key : value}];
}

// The designated event logger
-(void)logEvent:(NSString *)event withProperties:(NSDictionary *)dict {
    [[KeenClient sharedClient] addEvent:dict toEventCollection:event error:nil];
}

-(void)logEvent:(NSString *)event timed:(BOOL)timed {
    [self logEvent:event withProperties:@{}];
}

-(void)logEvent:(NSString *)event withProperties:(NSDictionary *)dict timed:(BOOL)timed {
    [self logEvent:event withProperties:dict];
}

-(void)endTimedEvent:(NSString *)event withProperties:(NSDictionary *)dict {}

-(void)logError:(NSString *)name message:(NSString *)message exception:(NSException *)exception {
    [[KeenClient sharedClient] addEvent:@{
                                          @"name" : name ? name : @"",
                                          @"message" : message ? message : @"",
                                          @"ename" : [exception name] ? [exception name] : @"",
                                          @"reason" : [exception reason] ? [exception reason] : @"",
                                          @"userInfo" : [exception userInfo] ? [exception userInfo] : @""
                                          }
                      toEventCollection:@"Exceptions" error:nil];
}
-(void)logError:(NSString *)name message:(NSString *)message error:(NSError *)error {
    NSParameterAssert(name);
    [[KeenClient sharedClient] addEvent:@{
                                          @"name" : name ? name : @"",
                                          @"message" : message ? message : @"",
                                          @"description" : [error localizedDescription] ? [error localizedDescription] : @"",
                                          @"code" : [NSString stringWithFormat:@"%zd" , [error code]],
                                          @"domain" : [error domain] ? [error domain] : @"",
                                          @"userInfo" : [error userInfo] ? [error userInfo] : @{}
                                          }
                      toEventCollection:@"Errors" error:nil];
}

@end
