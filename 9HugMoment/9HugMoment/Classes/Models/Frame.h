//
//  Frame.h
//  9HugMoment
//
//  Created by Nong Trung Nghia on 1/5/15.
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GetFrameFailureBlock)(NSError* error);
typedef void (^GetFrameSuccessBlock)();

@interface Frame : NSObject

@property (nonatomic,strong) NSString* thumbnailURLString;
@property (nonatomic,strong) NSString* detailURLString;

@property (nonatomic,readonly) UIImage* thumbnailImage;
@property (nonatomic,readonly) UIImage* detailImage;

+(Frame*)frameFromDictionary:(NSDictionary*)dict;

-(void)downloadThumbnailSuccess:(GetFrameSuccessBlock)success failure:(GetFrameFailureBlock)failure;
-(void)downloadDetailSuccess:(GetFrameSuccessBlock)success failure:(GetFrameFailureBlock)failure;

@end
