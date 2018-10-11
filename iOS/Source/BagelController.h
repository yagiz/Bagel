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

#import <Foundation/Foundation.h>

#import "BagelBrowser.h"
#import "BagelURLSessionInjector.h"
#import "BagelRequestCarrier.h"

#import "BagelURLSessionInjector.h"
#import "BagelURLConnectionInjector.h"

#import "BagelRequestPacket.h"

@interface BagelController : NSObject <BagelURLSessionInjectorDelegate, BagelURLConnectionInjectorDelegate>

@property (nonatomic, strong) BagelConfiguration* configuration;

@property (nonatomic, strong) BagelBrowser* browser;

@property (nonatomic, strong) BagelURLSessionInjector* urlSessionInjector;
@property (nonatomic, strong) BagelURLConnectionInjector* urlConnectionInjector;

@property (nonatomic, strong) NSMutableArray<BagelRequestCarrier*>* carriers;

- (instancetype)initWithConfiguration:(BagelConfiguration*)configuration;

@end

