//
//  BaggleNetworkRequest.h
//  Baggle
//
//  Created by Yagiz Gurgul on 03/05/2017.
//  Copyright © 2017 Kuka Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BagelProject;
@class BagelDevice;

@interface BagelRequestPacket : NSObject

@property (nonatomic,strong) NSString* packetId;

@property (nonatomic,strong) NSURL* url;

@property (nonatomic,strong) NSDictionary* requestHeaders;
@property (nonatomic,strong) NSData* requestBody;
@property (nonatomic,strong) NSString* requestMethod;


@property (nonatomic,strong) NSDictionary* responseHeaders;
@property (nonatomic,strong) NSData* responseData;

@property (nonatomic,strong) NSString* statusCode;

@property (nonatomic,strong) NSDate* startDate;
@property (nonatomic,strong) NSDate* endDate;

@property (nonatomic,strong) BagelProject* project;
@property (nonatomic,strong) BagelDevice* device;


@end
