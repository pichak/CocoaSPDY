//
//  SPDYTunnelStream.m
//  SPDY
//
//  Created by Morteza on 5/3/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import "SPDYTunnelStream.h"

@implementation SPDYTunnelStream {
    NSDictionary* _proxy;
    NSURLRequest* _request;
}

- (id)initWithRequest:(NSURLRequest*)request withProxySettings:(NSDictionary*)proxySettings tunnelDelegate:(id<SPDYTunnelStreamDelegate>)delegate
{
    if ( self = [super init] ) {
        _proxy = [proxySettings copy];
        _request = [request copy];
        self.tunnelDelegate = delegate;
    }
    return self;
}

- (void)didReceiveResponse:(NSDictionary *)headers
{
    NSLog(@"Received response");
    [self.tunnelDelegate establishSecureTunnel];
}

- (void)didLoadData:(NSData *)data
{
    NSLog(@"Received data");
    //[self.tunnelDelegate establishSecureTunnel];
}

- (NSDictionary*) headerFields
{
    NSString* host = [[_request.URL host] stringByAppendingString:@":443"];
    
    NSDictionary* headers = @{@":method": @"CONNECT",@":url":host,@":version":@"HTTP/1.1"};
    return headers;
}

@end
