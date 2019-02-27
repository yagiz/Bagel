//
// Copyright (c) 2018 Bagel (https://github.com/yagiz/Bagel)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BagelController.h"

static NSString* queueId = @"com.yagiz.bagel.injectController";

@implementation BagelController {
    dispatch_queue_t _queue;
}

- (instancetype)initWithConfiguration:(BagelConfiguration*)configuration
{
    self = [super init];

    if (self) {
        
        _queue = dispatch_queue_create((const char*)[queueId UTF8String], DISPATCH_QUEUE_SERIAL);
        self.carriers = [NSMutableArray new];
        
        self.configuration = configuration;

        if (!self.configuration) {
            self.configuration = [[BagelConfiguration alloc] init];
        }

        self.urlSessionInjector = [[BagelURLSessionInjector alloc] initWithDelegate:self];
        self.urlConnectionInjector = [[BagelURLConnectionInjector alloc] initWithDelegate:self];
        
        self.browser = [[BagelBrowser alloc] initWithConfiguration:self.configuration];
    }

    return self;
}

- (void)performBlock:(dispatch_block_t)block
{
    dispatch_async(_queue, block);
}

- (BagelRequestCarrier*)carrierWithURLSessionTask:(NSURLSessionTask*)urlSessionTask
{
    for (BagelRequestCarrier* carrier in self.carriers) {
        if (carrier.urlSessionTask == urlSessionTask) {
            return carrier;
        }
    }

    BagelRequestCarrier* carrier = [[BagelRequestCarrier alloc] initWithTask:urlSessionTask];
    [self.carriers addObject:carrier];

    return carrier;
}

- (BagelRequestCarrier*)carrierWithURLConnection:(NSURLConnection*)urlConnection
{
    for (BagelRequestCarrier* carrier in self.carriers) {
        if (carrier.urlConnection == urlConnection) {
            return carrier;
        }
    }
    
    BagelRequestCarrier* carrier = [[BagelRequestCarrier alloc] initWithURLConnection:urlConnection];
    [self.carriers addObject:carrier];
    
    return carrier;
}


- (void)urlSessionInjector:(BagelURLSessionInjector*)injector
                  didStart:(NSURLSessionDataTask*)dataTask
{
    [self performBlock:^{

        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];

        [self sendCarrier:carrier];

    }];
}

- (void)urlSessionInjector:(BagelURLSessionInjector*)injector
        didReceiveResponse:(NSURLSessionDataTask*)dataTask
                  response:(NSURLResponse*)response
{
    [self performBlock:^{

        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];

        carrier.response = response;
        
        [self sendCarrier:carrier];

    }];
}

- (void)urlSessionInjector:(BagelURLSessionInjector*)injector
            didReceiveData:(NSURLSessionDataTask*)dataTask
                      data:(NSData*)data
{
    NSData* copiedData = [data copy];

    [self performBlock:^{

        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];

        [carrier appenData:copiedData];

    }];
}

- (void)urlSessionInjector:(BagelURLSessionInjector*)injector
        didFinishWithError:(NSURLSessionDataTask*)dataTask
                     error:(NSError*)error
{
    [self performBlock:^{

        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];

        carrier.error = error;
        [carrier complete];
        
        [self sendCarrier:carrier];
        [self.carriers removeObject:carrier];
        
    }];
}







- (void)urlConnectionInjector:(BagelURLConnectionInjector *)injector didReceiveResponse:(NSURLConnection *)urlConnection response:(NSURLResponse *)response
{
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLConnection:urlConnection];
        
        carrier.response = response;
        
        [self sendCarrier:carrier];
        
    }];
}

- (void)urlConnectionInjector:(BagelURLConnectionInjector *)injector didReceiveData:(NSURLConnection *)urlConnection data:(NSData *)data
{
    NSData* copiedData = [data copy];
    
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLConnection:urlConnection];
        
        [carrier appenData:copiedData];
        
    }];
}

- (void)urlConnectionInjector:(BagelURLConnectionInjector *)injector didFailWithError:(NSURLConnection *)urlConnection error:(NSError *)error
{
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLConnection:urlConnection];
        
        carrier.error = error;
        [carrier complete];
        
        [self sendCarrier:carrier];
        [self.carriers removeObject:carrier];
        
    }];
}


- (void)urlConnectionInjector:(BagelURLConnectionInjector *)injector didFinishLoading:(NSURLConnection *)urlConnection
{
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLConnection:urlConnection];
        
        [carrier complete];
        
        [self sendCarrier:carrier];
        [self.carriers removeObject:carrier];
        
    }];
}


- (void)sendCarrier:(BagelRequestCarrier*)carrier
{
    BagelRequestPacket* packet = [carrier packet];

    packet.project = self.configuration.project;
    packet.device = self.configuration.device;

    id<BagelCarrierDelegate> carrierDelegate = self.configuration.carrierDelegate;
    if ([carrierDelegate respondsToSelector:@selector(bagelCarrierWillSendRequest:)]) {
        packet = [carrierDelegate bagelCarrierWillSendRequest:packet];
        
        if (packet == nil) {
            return;
        }
    }
    
    [self.browser sendPacket:packet];
}

@end
