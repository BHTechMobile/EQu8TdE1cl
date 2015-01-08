//
//  Filter.h
//  9HugMoment
//
//  Created by Nong Trung Nghia on 1/5/15.
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GetFilterSuccessBlock)();
typedef void (^GetFilterFailureBlock)(NSError* error);
typedef void (^GetFilterProgressBlock)(CGFloat percent);

@interface Filter : NSObject
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* thumbnail;
@property (nonatomic, strong) NSString* videourl;
@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSDictionary* properties;
@property (nonatomic, readonly) UIImage* thumbnailImage;

+(Filter*)filterFromDictionary:(NSDictionary*)dict;

-(void)downloadThumbnailSuccess:(GetFilterSuccessBlock)success failure:(GetFilterFailureBlock)failure;
- (void)downloadVideoSuccess:(GetFilterSuccessBlock)success failure:(GetFilterFailureBlock)failure progress:(GetFilterProgressBlock)progress;

@end
