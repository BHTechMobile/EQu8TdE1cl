//
//  Frame.m
//  9HugMoment
//
//  Created by Nong Trung Nghia on 1/5/15.
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import "Frame.h"
#import <SDWebImage/SDImageCache.h>

#define THUMBNAIL_KEY @"thumbnail"
#define DETAIL_KEY @"detail"

@implementation Frame

+(Frame*)frameFromDictionary:(NSDictionary*)dict{
    
    Frame* frame = [[Frame alloc] init];
    if ([dict valueForKey:THUMBNAIL_KEY]) {
        frame.thumbnailURLString = [dict valueForKey:THUMBNAIL_KEY];
    }
    if ([dict valueForKey:DETAIL_KEY]) {
        frame.detailURLString = [dict valueForKey:DETAIL_KEY];
    }
    [frame downloadThumbnailSuccess:nil failure:nil];
    [frame downloadDetailSuccess:nil failure:nil];
    
    return frame;
}

-(void)downloadThumbnailSuccess:(GetFrameSuccessBlock)success failure:(GetFrameFailureBlock)failure{
    _thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_thumbnailURLString];

    if (_thumbnailImage) {
        if (success) {
            success();
        }
    }
    else{
        NSURL *imageURL = [NSURL URLWithString:_thumbnailURLString];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
            if (!error) {
                if (image) {
                    _thumbnailImage = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:_thumbnailURLString];
                }
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success();
                    });

                }
            }else {
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
            }
        }];
    }
}

-(void)downloadDetailSuccess:(GetFrameSuccessBlock)success failure:(GetFrameFailureBlock)failure{
    _detailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_detailURLString];
    if (_detailImage) {
        if (success) {
            success();
        }
    }
    else{
        NSURL *imageURL = [NSURL URLWithString:_detailURLString];
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
            if (!error) {
                if (image) {
                    _detailImage = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:_detailURLString];
                }
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success();
                    });
                }
            }else {
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure(error);
                    });
                }
            }
        }];
    }
}

-(NSString*)description{
    return [NSString stringWithFormat:@"thumbnail:%@ is downloaded:%@ detail:%@ is downloaded:%@",_thumbnailURLString,(_thumbnailImage?@"YES":@"NO"),_detailURLString,(_detailImage?@"YES":@"NO")];
}

@end
