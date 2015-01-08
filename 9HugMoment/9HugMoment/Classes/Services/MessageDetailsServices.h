//
//  MessageDetailsServices.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^MessageBlock)(NSString* bodyString, NSError *error);
typedef void (^DownloadResponseBlock)(float progress);

@interface MessageDetailsServices : NSObject

+ (void)getMessageByKey:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure;
+ (void)uploadAudioWithToken:(NSDictionary *)param path:(NSURL*)audioPath sussess:(SuccessBlock)success failure:(MessageBlock)failure;
+ (void)uploadImage:(NSDictionary *)param path:(NSURL*)imagePath sussess:(SuccessBlock)success failure:(MessageBlock)failure;
+ (void)responseMessage:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)downloadUserImageWithFacebookID:(NSString *)facebookID success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)downloadAudio:(NSString *)baseUrl sussess:(SuccessBlock)success failure:(FailureBlock)failure progress:(DownloadResponseBlock)progress;

@end
