//
//  BagelBaseModel.h
//  Bagel
//
//  Created by Yagiz Gurgul on 27/05/2017.
//  Copyright © 2017 Yagiz Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BagelBaseModelProtocol <NSObject>

- (NSMutableDictionary*)toJSON;
- (instancetype)initWithJSON:(NSMutableDictionary*)json;

@end

@interface BagelBaseModel : NSObject

@end
