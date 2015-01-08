//
//  MessageDetailsServices.m
//  9HugMoment
//

#import "MessageDetailsServices.h"

#define TIME_OUT_INTERVAL_MESSAGE_DETAILS_SERVICES 10

@implementation MessageDetailsServices

+(AFHTTPRequestOperationManager*)sharedManager{
    AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://ws.9hug.com/api/"]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL_MESSAGE_DETAILS_SERVICES];
    }
    return manager;
}

+(void)requestByMethod:(NSString*)method widthPath:(NSString*)path withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableURLRequest *request = [[MessageDetailsServices sharedManager].requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[MessageDetailsServices sharedManager].baseURL] absoluteString] parameters:dict error:nil];
    
    AFHTTPRequestOperation *operation =
    [[MessageDetailsServices sharedManager] HTTPRequestOperationWithRequest:request
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
    [[MessageDetailsServices sharedManager].operationQueue addOperation:operation];
    
}

+ (void)getMessageByKey:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure{
    NSDictionary* parameters = @{KEY_KEY:key, KEY_REFRESH_REQUEST:@"1"};
    //@"token":@"9813bd3a1c9056f8b1449659299205f5"};
    [[MessageDetailsServices sharedManager].requestSerializer setTimeoutInterval:30];
    
    [MessageDetailsServices requestByMethod:@"GET" widthPath:@"message/get" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)uploadAudioWithToken:(NSDictionary *)param path:(NSURL*)audioPath sussess:(SuccessBlock)success failure:(MessageBlock)failure
{
    [[MessageDetailsServices sharedManager].requestSerializer setTimeoutInterval:300];
    
    AFHTTPRequestOperation* operator = [[MessageDetailsServices sharedManager] POST:@"message/response" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                        {
                                            NSData *audioData = [NSData dataWithContentsOfURL:audioPath];
                                            if (audioData == nil) {
                                                NSError* error = [NSError errorWithDomain:@"DataIsEmpty" code:404 userInfo:nil];
                                                failure(nil,error);
                                                return;
                                            }
                                            NSString *nameAudio = [NSString stringWithFormat:@"%@.aac",[NSString generateRandomString:8]];
                                            [formData appendPartWithFileData:audioData name:@"media_link" fileName:nameAudio mimeType:@"audio/x-hx-aac-adts"];
                                            
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
        NSLog(@"%lu /%lld",(unsigned long)totalBytesWritten,totalBytesWritten);
    }];
}

+ (void)uploadImage:(NSDictionary *)param path:(NSURL*)imagePath sussess:(SuccessBlock)success failure:(MessageBlock)failure
{
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    
    dispatch_async(backgroundQueue, ^{
        UIImage *fetchImage = [Utilities setThumbnail:[UIImage imageWithContentsOfFile:URL_ATTACH_IMAGE] withSize:CGSizeMake(720, 720)];
        
        [[MessageDetailsServices sharedManager].requestSerializer setTimeoutInterval:300];
        
        AFHTTPRequestOperation* operator = [[MessageDetailsServices sharedManager] POST:@"message/response" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                            {
                                                
                                                
                                                NSData *imageData = UIImagePNGRepresentation(fetchImage);
                                                if (imageData == nil) {
                                                    NSError* error = [NSError errorWithDomain:@"DataIsEmpty" code:404 userInfo:nil];
                                                    failure(nil,error);
                                                    return;
                                                }
                                                NSString *nameAudio = [NSString stringWithFormat:@"%@.jpg",[NSString generateRandomString:8]];
                                                [formData appendPartWithFileData:imageData name:@"media_link" fileName:nameAudio mimeType:@"jpeg/jpg"];
                                                
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
            NSLog(@"%lu /%lld",(unsigned long)totalBytesWritten,totalBytesExpectedToWrite);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

+ (void)responseMessage:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[MessageDetailsServices sharedManager].requestSerializer setTimeoutInterval:30];
    [[MessageDetailsServices sharedManager] POST:@"message/response" parameters:dicParam
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

+ (id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}

+ (void)downloadAudio:(NSString *)baseUrl sussess:(SuccessBlock)success failure:(FailureBlock)failure progress:(DownloadResponseBlock)progress{
    NSString* fileName = [NSString stringWithFormat:@"Documents/%@",[[baseUrl pathComponents] lastObject]];
    NSString *urlOutPut2 = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    
    AFHTTPRequestOperationManager* manager = [BaseServices sharedManager];
    [manager.requestSerializer setTimeoutInterval:300];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *operation = [manager GET:baseUrl
                                          parameters:nil
                                             success:^(AFHTTPRequestOperation *operation, NSData *responseData)
                                         {
                                             if (success) {
                                                 success(operation,responseData);
                                             }
                                         }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                         {
                                             NSLog(@"Downloading error: %@", error);
                                         }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         //         [someProgressView setProgress:downloadPercentage animated:YES];
     }];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:urlOutPut2 append:YES];
}

@end
