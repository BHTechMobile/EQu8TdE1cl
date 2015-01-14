//
//  MixVideoServices.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^MessageBlock)(NSString* bodyString, NSError *error);
typedef void (^DownloadResponseBlock)(float progress);

@interface MixVideoServices : NSObject

+ (void)updateMessage:(NSString*)message key:(NSString*)key frame:(NSString*)frame path:(NSURL*)videoPath latitude:(NSString*)latitude longitude:(NSString *)longitude notification:(BOOL)notiF isPublic:(BOOL)isPublic scheduled:(NSString*)scheduled thumbnail:(UIImage*)image sussess:(SuccessBlock)success failure:(MessageBlock)failure progress:(ProgressBlock)progress;

@end
