//
//  BaggleBounjourBrowser.h
//  Baggle
//
//  Created by Yagiz Gurgul on 03/05/2017.
//  Copyright © 2017 Kuka Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "BagelRequestPacket.h"
#import "BagelConstants.h"

@interface BagelBrowser : NSObject <GCDAsyncSocketDelegate,NSNetServiceDelegate,NSNetServiceBrowserDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSNetServiceBrowser *serviceBrowser;

+ (instancetype)shared;

- (void)startBrowsing;
- (void)sendPacket:(BagelRequestPacket*)packet;

@end
