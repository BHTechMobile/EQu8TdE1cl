//
//  ImageCacheObject.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@interface ImageCacheObject : NSObject

@property (nonatomic,strong) NSCache *imageCache;

+ (ImageCacheObject *)shareImageCache;
- (UIImage *)getImageFromCacheWithKey:(NSString *)imageKey;
- (void)setImageToCacheWithImage:(UIImage *)image andKey:(NSString *)imageKey;

@end
