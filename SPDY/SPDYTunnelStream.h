//
//  SPDYTunnelStream.h
//  SPDY
//
//  Created by Morteza on 5/3/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import "SPDYStream.h"

@protocol SPDYTunnelStreamDelegate <NSObject>
- (void)establishSecureTunnel;
@end

@interface SPDYTunnelStream : SPDYStream

@property (nonatomic, weak) id<SPDYTunnelStreamDelegate> tunnelDelegate;
@property (nonatomic, readonly) NSDictionary* headerFields;

- (id)initWithRequest:(NSURLRequest*)request withProxySettings:(NSDictionary*)proxySettings tunnelDelegate:(id<SPDYTunnelStreamDelegate>)delegate;
@end
