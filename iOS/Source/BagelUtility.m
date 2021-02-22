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

@import Foundation;

#if TARGET_OS_IOS
@import UIKit;
#endif

#import "BagelUtility.h"

@implementation BagelUtility

+ (NSString*)UUID
{
    return [[NSUUID UUID] UUIDString];
}

+ (NSString*)projectName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
}

+ (NSString*)deviceId
{
    return [NSString stringWithFormat:@"%@-%@", [self deviceName], [self deviceDescription]];
}

+ (NSString*)deviceName
{
#if TARGET_OS_IOS
  return [UIDevice currentDevice].name;
#else
  return [[NSHost currentHost] localizedName];
#endif
}

+ (NSString*)deviceDescription
{
    NSString* information = nil;

#if TARGET_OS_IOS
    information = [UIDevice currentDevice].model;
    information = [NSString stringWithFormat:@"%@ %@", information, [UIDevice currentDevice].systemName];
    information = [NSString stringWithFormat:@"%@ %@", information, [UIDevice currentDevice].systemVersion];
#else
    information = [[NSProcessInfo processInfo] operatingSystemVersionString];
#endif
    return information;
}

@end


