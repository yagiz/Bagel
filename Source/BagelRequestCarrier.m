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

#import "BagelRequestCarrier.h"
#import "BagelUtility.h"

@implementation BagelRequestCarrier

- (instancetype)initWithTask:(NSURLSessionTask*)task
{
    self = [super init];
    
    if(self)
    {
        self.request = task.originalRequest;
        self.task = task;
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    self.carrierId = [BagelUtility UUID];
    
    self.startDate = [NSDate date];
    
    self.data = nil;
    self.isCompleted = NO;
}

- (void)appenData:(NSData*)data
{
    if(self.data == nil)
    {
        self.data = [NSMutableData dataWithData:data];
    }else
    {
        [self.data appendData:data];
    }
    
    if(self.task && self.task.response)
    {
        self.response = self.task.response;
    }
}

- (void)complete
{
    self.task = nil;
    self.endDate = [NSDate date];
}


- (BagelRequestPacket*)packet
{
    BagelRequestPacket* packet = [[BagelRequestPacket alloc] init];
    
    packet.packetId = self.carrierId;
    
    BagelRequestInfo* requestInfo = [[BagelRequestInfo alloc] init];
    requestInfo.url = self.request.URL;
    requestInfo.requestHeaders = self.request.allHTTPHeaderFields;
    requestInfo.requestBody = self.request.HTTPBody;
    requestInfo.requestMethod = self.request.HTTPMethod;
    
    NSHTTPURLResponse* httpURLReqponse = (NSHTTPURLResponse*)self.response;
    requestInfo.responseHeaders = httpURLReqponse.allHeaderFields;
    
    requestInfo.responseData = self.data;
    
    requestInfo.statusCode = [NSString stringWithFormat:@"%ld",(long)httpURLReqponse.statusCode];
    
    requestInfo.startDate = self.startDate;
    requestInfo.endDate = self.endDate;
    
    packet.requestInfo = requestInfo;
    
    return packet;
}

@end
