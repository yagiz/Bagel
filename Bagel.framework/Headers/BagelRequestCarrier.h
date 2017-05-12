//
//  KMNetworkRequest.h
//  1V1Y.COM
//
//  Created by Yagiz Gurgul on 25/09/16.
//  Copyright © 2016 Kuka Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BagelRequestPacket.h"

@interface BagelRequestCarrier : NSObject

@property (nonatomic,strong) NSString* carrierId;

@property (nonatomic,weak) NSURLSessionTask* task;
@property (nonatomic,weak) NSURLConnection* connection;

@property (nonatomic,strong) NSURLRequest* request;
@property (nonatomic,strong) NSURLResponse* response;

@property (nonatomic,strong) NSDate* startDate;
@property (nonatomic,strong) NSDate* endDate;

@property (nonatomic,strong) NSMutableData* data;
@property (nonatomic,strong) NSError* error;

@property (nonatomic) BOOL isCompleted;

- (instancetype)initWithTask:(NSURLSessionTask*)task;
- (instancetype)initWithConnection:(NSURLConnection*)connection;

- (BagelRequestPacket*)packet;

- (void)appenData:(NSData*)data;
- (void)complete;

@end
