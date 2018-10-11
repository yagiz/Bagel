//
//  BagelURLConnectionInjector.h
//  Bagel
//
//  Created by Yagiz Gurgul on 11.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BagelURLConnectionInjector;

@protocol BagelURLConnectionInjectorDelegate

- (void)urlConnectionInjector:(BagelURLConnectionInjector*)injector didReceiveResponse:(NSURLConnection*)urlConnection response:(NSURLResponse*)response;

- (void)urlConnectionInjector:(BagelURLConnectionInjector*)injector didReceiveData:(NSURLConnection*)urlConnection data:(NSData*)data;

- (void)urlConnectionInjector:(BagelURLConnectionInjector*)injector didFailWithError:(NSURLConnection*)urlConnection error:(NSError*)error;

- (void)urlConnectionInjector:(BagelURLConnectionInjector*)injector didFinishLoading:(NSURLConnection*)urlConnection;

@end

@interface BagelURLConnectionInjector : NSObject

@property (nonatomic, weak) id<BagelURLConnectionInjectorDelegate> delegate;

- (instancetype)initWithDelegate:(id<BagelURLConnectionInjectorDelegate>)delegate;

- (void)inject;

@end
