//
//  ImageCacheObject.m
//  9HugMoment
//

#import "ImageCacheObject.h"

@implementation ImageCacheObject

+ (ImageCacheObject *)shareImageCache
{
    //singleton object
    static ImageCacheObject *imageCacheObject = nil;
    if (!imageCacheObject) {
        imageCacheObject = [[ImageCacheObject alloc] init];
        imageCacheObject.imageCache = [[NSCache alloc] init];
    }
    return imageCacheObject;
}

#pragma mark - Caches Management

- (UIImage *)getImageFromCacheWithKey:(NSString *)imageKey
{
    UIImage *image = [_imageCache objectForKey:imageKey];
    return image;
}

- (void)setImageToCacheWithImage:(UIImage *)image andKey:(NSString *)imageKey
{
    [_imageCache setObject:image forKey:imageKey];
}

@end
