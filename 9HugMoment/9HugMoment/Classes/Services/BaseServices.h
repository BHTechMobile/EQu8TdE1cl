//
//  BaseServices.h
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MessageObject.h"
#import "UIImageView+WebCache.h"

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^MessageBlock)(NSString* bodyString, NSError *error);
typedef void (^DownloadResponseBlock)(float progress);

@interface BaseServices : NSObject

+(AFHTTPRequestOperationManager*)sharedManager;

+ (void)createAccount9Hug:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)loginClient9Hug:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUserInfo:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure;

+(void)loginWithCode:(NSString*)code fullName:(NSString*)fullName fbID:(NSString*)fbid fbToken:(NSString*)fbToken nickname:(NSString*)nickname mobile:(NSString*)mobile email:(NSString*)email password:(NSString*)password success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)requestByMethod:(NSString*)method widthPath:(NSString*)path withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)uploadAudioWithToken:(NSDictionary *)param path:(NSURL*)audioPath sussess:(SuccessBlock)success failure:(MessageBlock)failure;

+ (void)getMessageByKey:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure;

+ (void)updateMessage:(NSString*)message key:(NSString*)key frame:(NSString*)frame path:(NSURL*)videoPath
             latitude:(NSString*)latitude longitude:(NSString *)longitude
         notification:(BOOL)notiF thumbnail:(UIImage*)image sussess:(SuccessBlock)success failure:(MessageBlock)failure;

+(void)getAllMessageSussess:(SuccessBlock)success failure:(MessageBlock)failure;
+(void)getMyMessageSussess:(SuccessBlock)success failure:(MessageBlock)failure;

+(void)resetMessage:(MessageObject *)message Sussess:(SuccessBlock)success failure:(MessageBlock)failure;

+(void)downloadVideoUrl:(NSString*)videoUrl outputPath:(NSString*)outputPath sussess:(SuccessBlock)success failure:(FailureBlock)failure progress:(DownloadResponseBlock)progress;

+(void)uploadImage:(NSDictionary *)param path:(NSURL*)imagePath sussess:(SuccessBlock)success failure:(MessageBlock)failure;

+ (void)downloadAudio:(NSString *)baseUrl  sussess:(SuccessBlock)success failure:(FailureBlock)failure progress:(DownloadResponseBlock)progress;
+ (void)createUserWithParam:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)createToken:(NSString *)email withPassword:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)createMomentForUser:(NSString *)token withType:(NSString *)type success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)generateImage:(NSURL*)url success:(void(^)(UIImage* image))success failure:(void(^)(NSError* error))failure;

+ (void)responseMessage:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)downloadUserImageWithFacebookID:(NSString *)facebookID success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
