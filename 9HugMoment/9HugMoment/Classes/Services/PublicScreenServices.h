//
//  PublicScreenServices.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^PublicScreenBlock)(NSString* bodyString, NSError *error);
typedef void (^DownloadResponseBlock)(float progress);

@interface PublicScreenServices : NSObject

+ (AFHTTPRequestOperationManager*)sharedManager;
+ (void)getAllMessageSussess:(SuccessBlock)success failure:(MessageBlock)failure;
+ (void)resetMessage:(MessageObject *)message Sussess:(SuccessBlock)success failure:(MessageBlock)failure;
+ (void)responseMessage:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
