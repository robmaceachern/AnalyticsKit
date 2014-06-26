//
//  AnalyticsKitKeenIOProvider.h
//  AnalyticsKit
//
//  Created by Rob MacEachern on 2014-06-26.
//  Copyright (c) 2014 Two Bit Labs. All rights reserved.
//

#import "AnalyticsKit.h"

@interface AnalyticsKitKeenIOProvider : NSObject <AnalyticsKitProvider>

-(id<AnalyticsKitProvider>)initWithProjectId:(NSString *)projectId writeKey:(NSString *)writeKey readKey:(NSString *)readKey geolocationEnabled:(BOOL)gelocationEnabled;

@end
