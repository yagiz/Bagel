//
//  BaggleDevice.h
//  BaggleDesktop
//
//  Created by Yagiz Gurgul on 08/05/2017.
//  Copyright © 2017 Yagiz Lab. All rights reserved.
//

#import "JSONModel.h"

@interface BagelDevice : JSONModel

@property (nonatomic,strong) NSString* deviceName;
@property (nonatomic,strong) NSString* deviceDescription;

@end
