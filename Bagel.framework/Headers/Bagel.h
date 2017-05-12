//
//  Bagel.h
//  Bagel
//
//  Created by Yagiz Gurgul on 12/05/2017.
//  Copyright © 2017 Yagiz Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Bagel.
FOUNDATION_EXPORT double BagelVersionNumber;

//! Project version string for Bagel.
FOUNDATION_EXPORT const unsigned char BagelVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Bagel/PublicHeader.h>

#import "BagelRequestCarrier.h"
#import "BagelProject.h"
#import "BagelDevice.h"

@interface Bagel : NSObject

+ (instancetype)shared;

@property (nonatomic,strong) BagelProject* project;
@property (nonatomic,strong) BagelDevice* device;

- (void)requestDidStart:(BagelRequestCarrier*)request;
- (void)requestDidFinishWithError:(BagelRequestCarrier*)requestCarrier error:(NSError*)error;

- (void)start;

@end
