//
//  ZmqTest_m.m
//  Example-iOS
//
//  Created by Ray Li on 9/24/19.
//  Copyright © 2019 azawawi. All rights reserved.
//

#import "ZmqTest.h"
#import "Example_iOS-Swift.h"

@implementation ZmqTest

- (void) test {
    NSLog(@"testing send and recv");
//    STSwift* st = [STSwift new];//[[STSwift alloc]];// initWithId:"abc"];
    NSError* err = nil;
    STSwift* st = [[STSwift alloc] initWithId:@"abc" error:&err];
    [st notify:^(NSString* src, NSArray<NSData*>* data) {
        NSLog(@"data received from: %@, msg count: %lu", src, [data count]);
        for (NSData* msg in data) {
            NSLog(@"%@", [[NSString alloc] initWithData:msg encoding:NSUTF8StringEncoding]);
        }
    }];
    [st sendWithDest:@"123" msg:@"hello from objc" error:&err];
}

@end
