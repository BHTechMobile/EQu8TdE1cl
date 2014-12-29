//
//  BaseServices.h
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"

typedef void (^SuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^FailureBlock)(AFHTTPRequestOperation *operation, NSError *error);
typedef void (^ProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

typedef void (^MessageBlock)(NSString* bodyString, NSError *error);
typedef void (^DownloadResponseBlock)(float progress);

@interface BaseServices : NSObject

+(AFHTTPRequestOperationManager*)sharedManager;

+(void)loginWithCode:(NSString*)code fullName:(NSString*)fullName fbID:(NSString*)fbid fbToken:(NSString*)fbToken nickname:(NSString*)nickname mobile:(NSString*)mobile email:(NSString*)email password:(NSString*)password success:(SuccessBlock)success failure:(FailureBlock)failure;

+(void)requestByMethod:(NSString*)method widthPath:(NSString*)path withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getMessageByKey:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure;


+ (void)createUserWithParam:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
