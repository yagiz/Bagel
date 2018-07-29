//
// Copyright (c) 2017 Bagel (https://github.com/yagiz/Bagel)
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

@implementation BagelController
{
    dispatch_queue_t _queue;
}

- (instancetype)initWithConfiguration:(BagelConfiguration* )configuration
{
    self = [super init];
    
    if(self)
    {
        self.configuration = configuration;
        
        if (!self.configuration)
        {
            self.configuration = [[BagelConfiguration alloc] init];
        }
        
        self.injector = [[BagelURLSessionInjector alloc] initWithDelegate:self];
        self.browser = [[BagelBrowser alloc] initWithConfiguration:self.configuration];
        
        self.carriers = [NSMutableArray new];

        _queue = dispatch_queue_create((const char*) [queueId UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}


- (void)performBlock:(dispatch_block_t )block
{
    dispatch_async(_queue, block);
}


- (BagelRequestCarrier*)carrierWithURLSessionTask:(NSURLSessionTask* )task
{
    for(BagelRequestCarrier* carrier in self.carriers)
    {
        if ([carrier.task isEqual:task])
        {
            return carrier;
        }
    }
    
    BagelRequestCarrier* carrier = [[BagelRequestCarrier alloc] initWithTask:task];
    [self.carriers addObject:carrier];
    
    return carrier;
}

- (void)urlSessionInjector:(BagelURLSessionInjector *)injector didStart:(NSURLSessionDataTask *)dataTask
{
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];

        [self sendCarrier:carrier];
        
    }];
}


- (void)urlSessionInjector:(BagelURLSessionInjector *)injector didReceiveResponse:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask response:(NSURLResponse *)response
{
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];
        
        carrier.response = response;
        [carrier complete];
        
        [self sendCarrier:carrier];
        
    }];
}


- (void)urlSessionInjector:(BagelURLSessionInjector *)injector didReceiveData:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask data:(NSData *)data
{
    NSData* copiedData = [data copy];
    
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];
        
        [carrier appenData:copiedData];
        
    }];
}


- (void)urlSessionInjector:(BagelURLSessionInjector *)injector didFinishWithError:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask error:(NSError *)error
{
    [self performBlock:^{
        
        BagelRequestCarrier* carrier = [self carrierWithURLSessionTask:dataTask];
        
        carrier.error = error;
        [carrier complete];
        
        [self sendCarrier:carrier];
        
    }];
}

- (void)sendCarrier:(BagelRequestCarrier*)carrier
{
    BagelRequestPacket* packet = [carrier packet];
    
    packet.project = self.configuration.project;
    packet.device = self.configuration.device;
    
    [self.browser sendPacket:packet];
}

@end
