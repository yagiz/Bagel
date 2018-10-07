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

#import "BagelRequestPacket.h"

@implementation BagelRequestPacket

- (instancetype)initWithJSON:(NSMutableDictionary*)json
{
    self = [super init];

    if (self) {
        if ([json objectForKey:@"packetId"]) {
            self.packetId = [json objectForKey:@"packetId"];
        }

        if ([json objectForKey:@"requestInfo"]) {
            self.requestInfo = [[BagelRequestInfo alloc] initWithJSON:[json objectForKey:@"requestInfo"]];
        }

        if ([json objectForKey:@"project"]) {
            self.project = [[BagelProjectModel alloc] initWithJSON:[json objectForKey:@"project"]];
        }

        if ([json objectForKey:@"device"]) {
            self.device = [[BagelDeviceModel alloc] initWithJSON:[json objectForKey:@"device"]];
        }

    }

    return self;
}

- (NSMutableDictionary*)toJSON
{
    NSMutableDictionary* json = [NSMutableDictionary new];

    if (self.packetId) {
        [json setObject:self.packetId forKey:@"packetId"];
    }

    if (self.requestInfo) {
        [json setObject:[self.requestInfo toJSON] forKey:@"requestInfo"];
    }

    if (self.project) {
        [json setObject:[self.project toJSON] forKey:@"project"];
    }

    if (self.device) {
        [json setObject:[self.device toJSON] forKey:@"device"];
    }

    return json;
}

@end
