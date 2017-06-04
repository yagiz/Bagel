//
//  BagelServer.h
//  Bagel
//
//  Created by Yagiz Gurgul on 02/05/2017.
//  Copyright © 2017 Kuka Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "BagelRequestPacket.h"
#import "BagelConstants.h"
#import "BagelConfiguration.h"

typedef enum : NSUInteger {
    BagelPublisherStatusNotConnected,
    BagelPublisherStatusConnected,
} BagelPublisherStatus;

@interface BagelPublisher : NSObject <GCDAsyncSocketDelegate,NSNetServiceDelegate,NSNetServiceBrowserDelegate>
@property (nonatomic, weak, readonly) BagelConfiguration* configuration;

@property (nonatomic) BagelPublisherStatus status;
@property (nonatomic, strong) NSNetService *service;

- (instancetype)initWithConfiguration:(BagelConfiguration*)configuration;

- (void)startPublishing;
- (void)sendPacket:(BagelRequestPacket*) packet;

@end
