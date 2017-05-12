//
//  NSURLSession+KMetrics.h
//  SwizzleTest
//
//  Created by Yagiz Gurgul on 18/08/16.
//  Copyright © 2016 KeyMetrics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BagelInjector: NSObject

+ (void)enableInjection;
+ (void)enableNSURLSessionInjection;
+ (void)enableNSURLConnectionDelegateInjection;

@end
