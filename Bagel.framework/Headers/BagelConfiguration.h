//
//  BagelConfiguration.h
//  Bagel
//
//  Created by Yagiz Gurgul on 04/06/2017.
//  Copyright © 2017 Yagiz Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BagelProject.h"
#import "BagelDevice.h"
#import "BagelUtility.h"

@interface BagelConfiguration : NSObject

@property (nonatomic,strong) BagelProject* project;
@property (nonatomic,strong) BagelDevice* device;

@property (nonatomic) BOOL isNSURLSessionInjectionEnabled;
@property (nonatomic) BOOL isNSURLConnectionDelegateInjection;

@property (nonatomic) uint16_t netservicePort;
@property (nonatomic,strong) NSString* netserviceType;
@property (nonatomic,strong) NSString* netserviceDomain;
@property (nonatomic,strong) NSString* netserviceName;

@end
