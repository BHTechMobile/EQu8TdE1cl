//
//  MeScreenServices.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^MeScreenBlock)(NSString* bodyString, NSError *error);
typedef void (^DownloadResponseBlock)(float progress);

@interface MeScreenServices : NSObject

+ (AFHTTPRequestOperationManager*)sharedManager;
+ (void)downloadUserImageWithFacebookID:(NSString *)facebookID success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUserStatistic:(NSDictionary*)parameters sussess:(SuccessBlock)success failure:(MessageBlock)failure;
+ (void)updateUserStatus:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUserStatus:(NSDictionary*)parameters sussess:(SuccessBlock)success failure:(MessageBlock)failure;

@end
