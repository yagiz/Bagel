//
//  Bagel.h
//  Bagel
//
//  Created by Yagiz Gurgul on 12/05/2017.
//  Copyright © 2017 Yagiz Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double BagelVersionNumber;
FOUNDATION_EXPORT const unsigned char BagelVersionString[];

#import "BagelRequestCarrier.h"
#import "BagelConfiguration.h"

@interface Bagel : NSObject

@property (nonatomic,strong) BagelConfiguration* configuration;

+ (instancetype)shared;

- (void)start;
- (void)startWithConfiguration:(BagelConfiguration*)configuration;

- (NSString*)version;

- (void)requestDidStart:(BagelRequestCarrier*)request;
- (void)requestRecieveResponse:(BagelRequestCarrier*)requestCarrier;
- (void)requestDidFinishWithError:(BagelRequestCarrier*)requestCarrier error:(NSError*)error;

@end
