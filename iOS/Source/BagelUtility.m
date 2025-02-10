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

#import "BagelUtility.h"

#if TARGET_OS_IPHONE
@import UIKit;
#endif

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
    #if TARGET_OS_IPHONE
    return [[UIDevice currentDevice] name];
    #elif TARGET_OS_MAC
    return [[NSHost currentHost] localizedName];
    #endif
}

+ (NSString*)deviceDescription
{
    #if TARGET_OS_IPHONE
    return [NSString stringWithFormat: @"%@ %@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
    #elif TARGET_OS_MAC
    NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    return [NSString stringWithFormat: @"%@ %ld.%ld.%ld", [[NSHost currentHost] localizedName], version.majorVersion, version.minorVersion, version.patchVersion];
    #endif
}

@end
