//
//  FrameModelTest.m
//  9HugMoment
//
//  Created by Nong Trung Nghia on 1/5/15.
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FramesModel.h"

@interface FrameModelTest : XCTestCase

@end

@implementation FrameModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    FramesModel * model = [FramesModel sharedFrames];
//    XCTAssertTrue(model.frames.count!=7,@"number of frames is not equal 7");
//    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
