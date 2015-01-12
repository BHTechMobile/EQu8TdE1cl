//
//  Filter.m
//  9HugMoment
//
//  Created by Nong Trung Nghia on 1/5/15.
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import "Filter.h"
#import <SDWebImage/SDImageCache.h>
#import <AFNetworking/AFNetworking.h>

#define FILTER_KEY_TYPE @"type"
#define FILTER_KEY_THUMBNAIL @"thumbnail"
#define FILTER_KEY_VIDEO @"videourl"
#define FILTER_KEY_PROPERTIES @"properties"
#define FILTER_KEY_CLASS_NAME @"classname"
#define FILTER_KEY_NAME @"name"

@implementation Filter

+(Filter*)filterFromDictionary:(NSDictionary*)dict{
    
    Filter* filter = [[Filter alloc] init];
    if ([dict valueForKey:FILTER_KEY_THUMBNAIL]) {
        filter.thumbnail = [dict valueForKey:FILTER_KEY_THUMBNAIL];
    }
    if ([dict valueForKey:FILTER_KEY_CLASS_NAME]) {
        filter.className = [dict valueForKey:FILTER_KEY_CLASS_NAME];
    }
    if ([dict valueForKey:FILTER_KEY_PROPERTIES]) {
        filter.properties = [dict valueForKey:FILTER_KEY_PROPERTIES];
    }
    if ([dict valueForKey:FILTER_KEY_NAME]) {
        filter.name = [dict valueForKey:FILTER_KEY_NAME];
    }
    if ([dict valueForKey:FILTER_KEY_TYPE]) {
        filter.type = [dict valueForKey:FILTER_KEY_TYPE];
    }
    
    if ([filter.type isEqualToString:@"dynamic"]) {
        if ([dict valueForKey:FILTER_KEY_VIDEO]) {
            filter.videourl = [dict valueForKey:FILTER_KEY_VIDEO];
        }
    }

    [filter downloadThumbnailSuccess:nil failure:nil];
    
    return filter;
}

-(void)downloadThumbnailSuccess:(GetFilterSuccessBlock)success failure:(GetFilterFailureBlock)failure{
    _thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_thumbnail];
    
    if (_thumbnailImage) {
        if (success) {
            success();
        }
    }
    else{
        NSURL *imageURL = [NSURL URLWithString:_thumbnail];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
            if (!error) {
                if (image) {
                    _thumbnailImage = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:_thumbnail];
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

- (void)downloadVideoSuccess:(GetFilterSuccessBlock)success failure:(GetFilterFailureBlock)failure progress:(GetFilterProgressBlock)progress{
    
    NSURL *videoURL = [NSURL URLWithString:_videourl];
    [self createFolderFiters];
    if ([self downloadedVideo]){
        if (success) {
            success();
        }
    }
    else{
        NSURLRequest *request = [NSURLRequest requestWithURL:videoURL];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        NSString *fullPath = [self localFilterPath];
        [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            if (progress) {
                progress((1.0*totalBytesRead)/(1.0*totalBytesExpectedToRead));
            }
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:_videourl];
            NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
            NSError *error;
            [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
            if (error) {
                NSLog(@"ERR: %@", [error description]);
                if (failure) {
                    failure(error);
                }
            } else {
                if (success) {
                    success();
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"ERR: %@", [error description]);
            if (failure) {
                failure(error);
            }
        }];
        
        [operation start];
    }
}

- (NSString*)description{
    return [NSString stringWithFormat:@"thumbnail:%@ is downloaded:%@ class:%@ name:%@ type:%@ videourl:%@",_thumbnail,(_thumbnailImage?@"YES":@"NO"),_className,_name,_type,_videourl];
}

#pragma mark - Custom Methods

- (NSString*)localFilterPath
{
    NSURL *videoURL = [NSURL URLWithString:_videourl];
    NSString *filterName = [videoURL lastPathComponent];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",PATH_COMPONET_FILTER,filterName];
    return [NSHomeDirectory() stringByAppendingPathComponent:fileName];
}

- (void)createFolderFiters
{
    // if folder doesn't exist, create it
    NSString *folderPath = [NSHomeDirectory() stringByAppendingPathComponent:PATH_COMPONET_FILTER];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:folderPath isDirectory:&isDir]) {
        BOOL success = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (!success || error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        NSAssert(success, @"Failed to create folder at path:%@", folderPath);
    }
}

- (BOOL)downloadedVideo{
    return ([[NSUserDefaults standardUserDefaults] objectForKey:_videourl])?YES:NO;
}

@end
