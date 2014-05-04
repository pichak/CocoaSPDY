//
//  SPDYConnectionTest.m
//  SPDY
//
//  Created by Morteza on 4/30/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <SPDY/SPDYProtocol.h>

@interface SPDYConnectionTest : SenTestCase

@end

@interface SPDYMockConnectionDelegate : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readwrite) BOOL *finished;
@end

@implementation SPDYMockConnectionDelegate
{
    NSMutableData *_data;
}

- (id)init
{
    self = [super init];
    if (self) {
        //_finished = NO;
        self.finished = NO;
        _data = [NSMutableData new];
    }
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"hello");
    self.finished = YES;
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"errored");
    self.finished = YES;
}

@end


@implementation SPDYConnectionTest

- (void)setUp
{
    [super setUp];
    SPDYConfiguration* config = [[SPDYConfiguration defaultConfiguration] copy];

    CFMutableDictionaryRef sslOption = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(sslOption, kCFStreamSSLValidatesCertificateChain, kCFBooleanFalse);
    NSNumber *port = [[NSNumber alloc] initWithUnsignedShort:3128];
    [config setProxySettings:@{@"host":@"localhost",@"port":port}];
    [config setEnableProxy:YES];
    [config setTlsSettings:(__bridge NSDictionary *)(sslOption)];
//    [SPDYURLConnectionProtocol registerOrigin:@"http://localhost:3128"];
    [SPDYURLConnectionProtocol setConfiguration:config];
    [SPDYURLConnectionProtocol registerOrigin:@"https://api.vpnintouch.in/"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSURL* url = [[NSURL alloc] initWithString:@"https://api.vpnintouch.in/"];
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];
    SPDYMockConnectionDelegate* delegate = [[SPDYMockConnectionDelegate alloc] init];
    NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:req delegate:delegate];
    [conn start];
    __block bool finished = NO;
    STAssertTrue([NSThread isMainThread], @"dispatch must occur from main thread");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STAssertFalse([NSThread isMainThread], @"stream must be scheduled off main thread");
        
        // Run off-thread runloop
        while(![delegate finished]) {
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            finished = YES;
        });
    });
    
    // Run main thread runloop
    while(!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }

    
}

@end
