//
//  BaggleServer.h
//  Baggle
//
//  Created by Yagiz Gurgul on 02/05/2017.
//  Copyright © 2017 Kuka Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "BagelRequestPacket.h"
#import "BagelConstants.h"

typedef enum : NSUInteger {
    BagelPublisherStatusNotConnected,
    BagelPublisherStatusConnected,
} BagelPublisherStatus;

@interface BagelPublisher : NSObject <GCDAsyncSocketDelegate,NSNetServiceDelegate,NSNetServiceBrowserDelegate>

@property (nonatomic) BagelPublisherStatus status;
@property (nonatomic, strong) NSNetService *service;

+ (instancetype)shared;

- (void)startPublishing;

@end
