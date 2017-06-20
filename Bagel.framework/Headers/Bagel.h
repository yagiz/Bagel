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

#import <Foundation/Foundation.h>
#import "BagelRequestCarrier.h"
#import "BagelConfiguration.h"

FOUNDATION_EXPORT double BagelVersionNumber;
FOUNDATION_EXPORT const unsigned char BagelVersionString[];

@interface Bagel : NSObject

@property (nonatomic,strong) BagelConfiguration* configuration;

+ (instancetype)shared;

- (void)start;
- (void)startWithConfiguration:(BagelConfiguration*)configuration;

- (void)appWillOpenUrl:(NSURL*)url;

- (NSString*)version;

- (void)requestRecieveResponse:(BagelRequestCarrier*)requestCarrier;
- (void)requestDidFinishWithError:(BagelRequestCarrier*)requestCarrier error:(NSError*)error;

@end
