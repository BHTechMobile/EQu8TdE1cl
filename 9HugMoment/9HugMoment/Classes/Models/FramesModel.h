//
//  FramesModel.h
//  9HugMoment
//
//  Created by Nong Trung Nghia on 1/5/15.
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FramesModel : NSObject

@property (nonatomic,readonly) NSArray* frames;

+ (FramesModel *)sharedFrames;

@end
