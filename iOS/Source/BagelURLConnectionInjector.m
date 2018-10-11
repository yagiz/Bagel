//
//  BagelURLConnectionInjector.m
//  Bagel
//
//  Created by Yagiz Gurgul on 11.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

#import "BagelURLConnectionInjector.h"
#import "Bagel.h"
#include <objc/runtime.h>

@implementation BagelURLConnectionInjector

- (instancetype)initWithDelegate:(id<BagelURLConnectionInjectorDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
        [self inject];
    }
    
    return self;
}

- (void)inject
{
    static dispatch_once_t NSURLConnectionDelegateInjection;
    
    dispatch_once(&NSURLConnectionDelegateInjection, ^{
        [self _inject];
    });
}

- (void)_inject
{
    unsigned int numOfClasses;
    Class *classes = objc_copyClassList(&numOfClasses);
    for (unsigned int i = 0; i < numOfClasses; i++) {
        
        Protocol *protocol = @protocol(NSURLConnectionDataDelegate);
        if (!protocol) {
            protocol = @protocol(NSURLConnectionDelegate);
        }
        
        if(class_conformsToProtocol(classes[i], protocol))
        {
            [self swizzleConnectionDidReceiveResponse:classes[i]];
            [self swizzleConnectionDidReceiveData:classes[i]];
            [self swizzleConnectionDidFailWithError:classes[i]];
            [self swizzleConnectionDidFinishLoading:classes[i]];
        }
    }
    
    free(classes);
}


-(void)swizzleConnectionDidReceiveResponse:(Class)class
{
    SEL selector = @selector(connection:didReceiveResponse:);
    Method m = class_getInstanceMethod(class, selector);
    
    if(m && [class instancesRespondToSelector:selector])
    {
        
        typedef void (*OriginalIMPBlockType)(id self,SEL _cmd, NSURLConnection* connection, NSURLResponse* response);
        OriginalIMPBlockType originalIMPBlock = (OriginalIMPBlockType)method_getImplementation(m);
        
        __weak BagelURLConnectionInjector* weakSelf = self;
        
        void (^swizzleConnectionDidReceiveResponse)(id, NSURLConnection*, NSURLResponse*) = ^void  (id self, NSURLConnection* connection,NSURLResponse* response) {
            
            [weakSelf.delegate urlConnectionInjector:weakSelf didReceiveResponse:connection response:response];
            originalIMPBlock(self,_cmd,connection,response);
        };
        
        method_setImplementation(m,imp_implementationWithBlock(swizzleConnectionDidReceiveResponse));
    }
}

- (void)swizzleConnectionDidReceiveData:(Class)class
{
    SEL selector = @selector(connection:didReceiveData:);
    Method m = class_getInstanceMethod(class, selector);
    
    if(m && [class instancesRespondToSelector:selector])
    {
        
        typedef void (*OriginalIMPBlockType)(id self,SEL _cmd, NSURLConnection* connection, NSData* data);
        OriginalIMPBlockType originalIMPBlock = (OriginalIMPBlockType)method_getImplementation(m);
        
        __weak BagelURLConnectionInjector* weakSelf = self;
        
        void (^swizzleConnectionDidReceiveData)(id, NSURLConnection*, NSData*) = ^void  (id self, NSURLConnection* connection,NSData* data) {
            

            [weakSelf.delegate urlConnectionInjector:weakSelf didReceiveData:connection data:data];
            originalIMPBlock(self,_cmd,connection,data);
        };
        
        method_setImplementation(m,imp_implementationWithBlock(swizzleConnectionDidReceiveData));
    }
}

- (void)swizzleConnectionDidFailWithError:(Class)class
{
    SEL selector = @selector(connection:didFailWithError:);
    Method m = class_getInstanceMethod(class, selector);
    
    if(m && [class instancesRespondToSelector:selector])
    {
        
        typedef void (*OriginalIMPBlockType)(id self,SEL _cmd, NSURLConnection* connection, NSError* error);
        OriginalIMPBlockType originalIMPBlock = (OriginalIMPBlockType)method_getImplementation(m);
        
        __weak BagelURLConnectionInjector* weakSelf = self;
        
        void (^swizzleConnectionDidFailWithError)(id, NSURLConnection*, NSError*) = ^void  (id self, NSURLConnection* connection,NSError* error) {
            
            [weakSelf.delegate urlConnectionInjector:weakSelf didFailWithError:connection error:error];
            originalIMPBlock(self,_cmd,connection,error);
        };
        
        method_setImplementation(m,imp_implementationWithBlock(swizzleConnectionDidFailWithError));
    }
}

- (void)swizzleConnectionDidFinishLoading:(Class)class
{
    SEL selector = @selector(connectionDidFinishLoading:);
    Method m = class_getInstanceMethod(class, selector);
    
    if(m && [class instancesRespondToSelector:selector])
    {
        
        typedef void (*OriginalIMPBlockType)(id self,SEL _cmd, NSURLConnection* connection);
        OriginalIMPBlockType originalIMPBlock = (OriginalIMPBlockType)method_getImplementation(m);
        
        __weak BagelURLConnectionInjector* weakSelf = self;
        
        void (^swizzleConnectionDidFinishLoading)(id, NSURLConnection*) = ^void  (id self, NSURLConnection* connection) {
            
            [weakSelf.delegate urlConnectionInjector:weakSelf didFinishLoading:connection];
            originalIMPBlock(self,_cmd,connection);
        };
        
        method_setImplementation(m,imp_implementationWithBlock(swizzleConnectionDidFinishLoading));
    }
}

@end
