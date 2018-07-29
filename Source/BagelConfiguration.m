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

#import "BagelConfiguration.h"

@implementation BagelConfiguration

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        BagelProjectModel* project = [[BagelProjectModel alloc] init];
        project.projectName = [BagelUtility projectName];
        
        BagelDeviceModel* device = [[BagelDeviceModel alloc] init];
        device.deviceId = [BagelUtility deviceId];
        device.deviceName = [BagelUtility deviceName];
        device.deviceDescription = [BagelUtility deviceDescription];
        
        self.project = project;
        self.device = device;
        
        self.netservicePort = 43434;
        self.netserviceDomain = @"";
        self.netserviceType = @"_Bagel._tcp";
        self.netserviceName = @"";
        
        self.deepLinkStarterURL = @"bagel";
    }
    
    return self;
}

@end
