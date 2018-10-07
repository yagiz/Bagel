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

#import "BagelConfiguration.h"

static BagelConfiguration* defaultConfiguration;

@implementation BagelConfiguration

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.project = [[BagelProjectModel alloc] init];
        self.device = [[BagelDeviceModel alloc] init];
    }
    
    return self;
}


+ (instancetype)defaultConfiguration
{
    if (!defaultConfiguration)
    {
        defaultConfiguration = [[BagelConfiguration alloc] init];

        BagelProjectModel* project = [[BagelProjectModel alloc] init];
        project.projectName = [BagelUtility projectName];

        BagelDeviceModel* device = [[BagelDeviceModel alloc] init];
        device.deviceId = [BagelUtility deviceId];
        device.deviceName = [BagelUtility deviceName];
        device.deviceDescription = [BagelUtility deviceDescription];

        defaultConfiguration.project = project;
        defaultConfiguration.device = device;

        defaultConfiguration.netservicePort = 43435;
        defaultConfiguration.netserviceDomain = @"";
        defaultConfiguration.netserviceType = @"_Bagel._tcp";
        defaultConfiguration.netserviceName = @"";
    }

    return defaultConfiguration;
}

@end
