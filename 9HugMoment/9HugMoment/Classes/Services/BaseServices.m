//
//  BaseServices.m
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "BaseServices.h"

#define TIME_OUT_INTERVAL 10

@implementation BaseServices

+(AFHTTPRequestOperationManager*)sharedManager{
    AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://ws.9hug.com/api/"]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL];
    }
    return manager;
}

+(void)requestByMethod:(NSString*)method widthPath:(NSString*)path withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableURLRequest *request = [[BaseServices sharedManager].requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[BaseServices sharedManager].baseURL] absoluteString] parameters:dict error:nil];
    
    AFHTTPRequestOperation *operation =
    [[BaseServices sharedManager] HTTPRequestOperationWithRequest:request
                                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                              
                                                              if (success) {
                                                                  success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                                                              }
                                                              
                                                          }
                                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                              
                                                              NSLog(@"%@",[operation responseString]);
                                                              
                                                              if (error.code == NSURLErrorCancelled) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
                                                              if (error.code == NSURLErrorNotConnectedToInternet) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
                                                              if (error.code == NSURLErrorTimedOut) {
                                                                  goto CALL_FAILURE;
                                                              }
                                                              
#ifdef APPDEBUG
                                                              [APP_DELEGATE alertView:@"Error" withMessage:@"Somethings was wrong, please contact to Developer" andButton:@"OK"];
#endif
                                                          CALL_FAILURE:
                                                              if (failure) {
                                                                  failure(operation,error);
                                                              }
                                                              
                                                          }];
    [[BaseServices sharedManager].operationQueue addOperation:operation];
    
}

#pragma mark - Create Account

+ (void)createAccount9Hug:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    [[BaseServices sharedManager] POST:@"client/create" parameters:dicParam
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                 
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
                 
             }];
    
}

+ (void)getUserInfo:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure{
    NSDictionary* parameters = @{@"key":key};
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    [BaseServices requestByMethod:@"GET" widthPath:@"user/get" withParameters:parameters
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              if (success) {
                                  success(operation,responseObject);
                              }
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                              NSString* bodyString = [operation responseString];
                              
                              if (failure) {
                                  failure(bodyString,error);
                              }
                              
                          }];
    
    
}

#pragma mark - Login Client

+ (void)loginClient9Hug:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    [[BaseServices sharedManager] POST:@"client/login" parameters:dicParam
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                 
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
                 
             }];
}

#pragma mark - Login/Logout Services

+ (void)createUserWithParam:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    [[BaseServices sharedManager] POST:@"user/create" parameters:dicParam
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
                 
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
                 
             }];
}

//+(void)loginWithCode:(NSString*)code fullName:(NSString*)fullName fbID:(NSString*)fbid fbToken:(NSString*)fbToken nickname:(NSString*)nickname mobile:(NSString*)mobile email:(NSString*)email password:(NSString*)password success:(SuccessBlock)success failure:(FailureBlock)failure{
//    
//    NSDictionary * params  = @{@"code":code,
//                               @"fullname":fullName,
//                               @"facebookid":fbid,
//                               @"facebook_token":fbToken,
//                               @"nickname":nickname,
//                               @"mobile":mobile,
//                               @"email":email,
//                               @"password":password
//                               };
//    NSLog(@"params %@",params);
//    //AFHTTPRequestOperation* operator =
//    
//    
//}
//
//#pragma mark - Login
//
//+ (void)createToken:(NSString *)email withPassword:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure{
//    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
//    NSDictionary* dict;
//    dict = @{@"email":email,
//             @"password":password
//             };
//    [[BaseServices sharedManager] POST:@"client/login" parameters:dict
//             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
//                 
//             } success:^(AFHTTPRequestOperation *operation, id responseObject){
//                 if (success) {
//                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
//                 }
//                 
//             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
//                 if (failure) {
//                     failure(nil,error);
//                 }
//             }];
//}

#pragma mark - Make QRCode

+ (void)createMomentForUser:(NSString *)userid withType:(NSString *)type success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    NSDictionary* dict = @{@"userid":userid,
                           @"type":type
                           };
    
    [[BaseServices sharedManager] POST:@"message/create" parameters:dict
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
             }];
}

#pragma mark - Message Services

+ (void)getMessageByKey:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure{
    NSDictionary* parameters = @{KEY_KEY:key, KEY_REFRESH_REQUEST:@"1"};
    //@"token":@"9813bd3a1c9056f8b1449659299205f5"};
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    
    [BaseServices requestByMethod:@"GET" widthPath:@"message/get" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString* bodyString = [operation responseString];
        
        if (failure) {
            failure(bodyString,error);
        }
    }];
}

+ (void)generateImage:(NSURL*)url success:(void(^)(UIImage* image))success failure:(void(^)(NSError* error))failure{
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        if (success) {
            success([UIImage imageWithCGImage:im]);
        }
        else if (failure){
            failure(error);
        }
    };
    
    CGSize maxSize = CGSizeMake(640, 640);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}

+ (void)updateMessage:(NSString*)message key:(NSString*)key frame:(NSString*)frame path:(NSURL*)videoPath
             latitude:(NSString*)latitude longitude:(NSString *)longitude
         notification:(BOOL)notiF thumbnail:(UIImage*)image sussess:(SuccessBlock)success failure:(MessageBlock)failure;
{
    NSDictionary* dict;
    dict = @{@"key":key,
             @"text":message,
             @"frameid":frame,
             @"latitude":latitude,
             @"longitude":longitude,
             @"notification":@(notiF),
             @"userid":[[UserData currentAccount] strId]
             };
    
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:300];
    
    AFHTTPRequestOperation* operator = [[BaseServices sharedManager] POST:@"message/update" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                        {
                                            NSData *videoData = [NSData dataWithContentsOfURL:videoPath];
                                            if (videoData == nil) {
                                                NSError* error = [NSError errorWithDomain:@"DataIsEmpty" code:404 userInfo:nil];
                                                failure(nil,error);
                                                return;
                                            }
                                            
                                            [formData appendPartWithFileData:videoData name:@"attachement1" fileName:@"video.mp4" mimeType:@"video/mp4"];
                                            
                                            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"attachement2" fileName:@"thumbnail.png" mimeType:@"image/png"];

                                            
                                        } success:^(AFHTTPRequestOperation *operation, id responseObject)
                                        {
                                            if (success) {
                                                success(operation,responseObject);
                                            }
                                            
                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                        {
                                            if (failure) {
                                                failure([operation responseString],error);
                                            }
                                            
                                        }];
    [operator setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}

+(void)getAllMessageSussess:(SuccessBlock)success failure:(MessageBlock)failure
{
    NSDictionary* parameters = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                                 @"idisplaylength":@999,
                                 @"refresh":@1};
    
    [BaseServices requestByMethod:@"GET" widthPath:@"message/browse" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* bodyString = [operation responseString];
        if (failure) {
            failure(bodyString,error);
        }
    }];
}

+(void)getMyMessageSussess:(SuccessBlock)success failure:(MessageBlock)failure{
    NSDictionary* parameters = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                                 KEY_USER_ID: [UserData currentAccount].strId,
                                 @"idisplaylength":@999,
                                 @"refresh":@1};
    
    [BaseServices requestByMethod:@"GET" widthPath:@"message/browse" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* bodyString = [operation responseString];
        if (failure) {
            failure(bodyString,error);
        }
    }];
}

+(void)resetMessage:(MessageObject *)message Sussess:(SuccessBlock)success failure:(MessageBlock)failure
{
    NSDictionary* parameters = @{KEY_USER_ID:[NSUserDefaults getStringForKey:KEY_USER_SETTING_LOGGED_IN_ID]};
    
    [BaseServices requestByMethod:@"GET" widthPath:[NSString stringWithFormat:@"message/reset?code=%@",message.code] withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* bodyString = [operation responseString];
        if (failure) {
            failure(bodyString,error);
        }
    }];
}

+(void)downloadVideoUrl:(NSString*)videoUrl outputPath:(NSString*)outputPath sussess:(SuccessBlock)success failure:(FailureBlock)failure progress:(DownloadResponseBlock)progress{
    AFHTTPRequestOperationManager* manager = [BaseServices sharedManager];
    [manager.requestSerializer setTimeoutInterval:300];
    AFHTTPRequestOperation *op = [manager GET:videoUrl
                                   parameters:nil
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSLog(@"success");
                                          if (success) {
                                              success(operation,responseObject);
                                          }
                                          
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                          if (error.code == NSURLErrorCancelled) {
                                              return;
                                          }
                                          
                                          if (error.code == NSURLErrorNotConnectedToInternet) {
                                              [UIAlertView showTitle:@"Error" message:@"Cannot connect to server."];
                                              return;
                                          }
                                          
                                          if (error.code == NSURLErrorTimedOut) {
                                              [UIAlertView showTitle:@"Error" message:@"Connection timeout."];
                                              return;
                                          }
                                          
                                          if (failure) {
                                              failure(operation,error);
                                          }
                                      }];
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float pg = totalBytesRead / (float)totalBytesExpectedToRead;
        if (progress) {
            progress(pg);
        }
    }];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:outputPath append:YES];
}

+ (void)responseMessage:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[BaseServices sharedManager].requestSerializer setTimeoutInterval:30];
    [[BaseServices sharedManager] POST:@"message/response" parameters:dicParam
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
             } success:^(AFHTTPRequestOperation *operation, id responseObject){
                 if (success) {
                     success(operation,[[self class] dictionaryFromData:operation.responseData error:nil]);
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 if (failure) {
                     failure(nil,error);
                 }
             }];
}

#pragma mark - Utilities

+(id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}

+ (void)downloadUserImageWithFacebookID:(NSString *)facebookID success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",facebookID]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        if (!error) {
            if (success) {
                UIImage *defaultUserCommentPhoto = [UIImage imageNamed:IMAGE_NAME_THUMB_PLACE_HOLDER];
                if (image) {
                    success(nil, image);
                }else {
                    success(nil, defaultUserCommentPhoto);
                }
            }
        }else {
            if (failure) {
                failure(nil, error);
            }
        }
    }];
}


@end
