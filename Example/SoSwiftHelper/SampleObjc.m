//
//  SampleObjc.m
//  SoSwiftHelper_Example
//
//  Created by wangteng on 2020/7/8.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

#import "SampleObjc.h"
#import "SoSwiftHelper-Swift.h"

@implementation SampleObjc

-(void)testLocation {
    SwiftHelperLocationManager *manager = [[SwiftHelperLocationManager alloc]  init];
    [manager start: LocationUpdateProxyOnce];
    [manager setDidUpdateLocations:^(NSArray<CLLocation *> * locations) {
        
    }];
}

@end
