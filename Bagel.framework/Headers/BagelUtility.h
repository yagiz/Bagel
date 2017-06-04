//
//  BagelUtility.h
//  Bagel
//
//  Created by Yagiz Gurgul on 08/05/2017.
//  Copyright © 2017 Kuka Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

@interface BagelUtility : NSObject

+ (NSString *)UUID;

+ (NSString *)projectName;

+ (NSString *)deviceName;
+ (NSString *)deviceDescription;

@end
