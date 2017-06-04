//
//  BagelNetworkRequest.h
//  Bagel
//
//  Created by Yagiz Gurgul on 03/05/2017.
//  Copyright © 2017 Kuka Apps. All rights reserved.
//

#import "BagelBaseModel.h"
#import "BagelProject.h"
#import "BagelDevice.h"

@interface BagelRequestPacket : NSObject <BagelBaseModelProtocol>

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

@property (nonatomic,strong) NSString* bagelVersion;

@property (nonatomic,strong) BagelProject* project;
@property (nonatomic,strong) BagelDevice* device;

@property (nonatomic,strong) NSString* ipAddress;

@end
