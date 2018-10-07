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

#import "BagelRequestInfo.h"

@implementation BagelRequestInfo

- (instancetype)initWithJSON:(NSMutableDictionary*)json
{
    self = [super init];

    if (self) {
        if ([json objectForKey:@"url"]) {
            self.url = [NSURL URLWithString:[json objectForKey:@"url"]];
        }

        if ([json objectForKey:@"requestHeaders"]) {
            self.requestHeaders = [json objectForKey:@"requestHeaders"];
        }

        if ([json objectForKey:@"requestMethod"]) {
            self.requestMethod = [json objectForKey:@"requestMethod"];
        }

        if ([json objectForKey:@"requestBody"]) {
            NSData* base64Data = [[NSData alloc] initWithBase64EncodedString:[json objectForKey:@"requestBody"] options:NSDataBase64DecodingIgnoreUnknownCharacters];

            self.requestBody = base64Data;
        }

        if ([json objectForKey:@"responseHeaders"]) {
            self.responseHeaders = [json objectForKey:@"responseHeaders"];
        }

        if ([json objectForKey:@"responseData"]) {
            NSData* base64Data = [[NSData alloc] initWithBase64EncodedString:[json objectForKey:@"responseData"] options:NSDataBase64DecodingIgnoreUnknownCharacters];

            self.responseData = base64Data;
        }

        if ([json objectForKey:@"statusCode"]) {
            self.statusCode = [json objectForKey:@"statusCode"];
        }

        if ([json objectForKey:@"startDate"]) {
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"startDate"] integerValue]];

            self.startDate = date;
        }

        if ([json objectForKey:@"endDate"]) {
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"endDate"] integerValue]];

            self.endDate = date;
        }
    }

    return self;
}

- (NSMutableDictionary*)toJSON
{
    NSMutableDictionary* json = [NSMutableDictionary new];

    if (self.url) {
        [json setObject:self.url.absoluteString forKey:@"url"];
    }

    if (self.requestHeaders) {
        [json setObject:self.requestHeaders forKey:@"requestHeaders"];
    }

    if (self.requestMethod) {
        [json setObject:self.requestMethod forKey:@"requestMethod"];
    }

    if (self.requestBody) {
        NSString* base64String = [self.requestBody base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

        if (base64String) {
            [json setObject:base64String forKey:@"requestBody"];
        }
    }

    if (self.responseHeaders) {
        [json setObject:self.responseHeaders forKey:@"responseHeaders"];
    }

    if (self.responseData) {
        NSString* base64String = [self.responseData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        if (base64String) {
            [json setObject:base64String forKey:@"responseData"];
        }
    }

    if (self.statusCode) {
        [json setObject:self.statusCode forKey:@"statusCode"];
    }

    if (self.startDate) {
        NSNumber* date = [NSNumber numberWithInteger:[self.startDate timeIntervalSince1970]];
        [json setObject:date forKey:@"startDate"];
    }

    if (self.endDate) {
        NSNumber* date = [NSNumber numberWithInteger:[self.endDate timeIntervalSince1970]];
        [json setObject:date forKey:@"endDate"];
    }

    return json;
}

@end
