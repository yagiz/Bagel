//
//  Bagel.h
//  Bagel
//
//  Created by Yagiz Gurgul on 12/05/2017.
//  Copyright © 2017 Yagiz Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double BagelVersionNumber;
FOUNDATION_EXPORT const unsigned char BagelVersionString[];

#import "BagelRequestCarrier.h"
#import "BagelProject.h"
#import "BagelDevice.h"

@interface Bagel : NSObject

+ (instancetype)shared;

@property (nonatomic,strong) BagelProject* project;
@property (nonatomic,strong) BagelDevice* device;

- (void)requestDidStart:(BagelRequestCarrier*)request;
- (void)requestRecieveResponse:(BagelRequestCarrier*)requestCarrier;
- (void)requestDidFinishWithError:(BagelRequestCarrier*)requestCarrier error:(NSError*)error;

- (void)start;

@end
