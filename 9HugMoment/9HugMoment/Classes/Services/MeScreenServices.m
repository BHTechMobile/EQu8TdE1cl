//
//  MeScreenServices.m
//  9HugMoment
//

#import "MeScreenServices.h"

#define TIME_OUT_INTERVAL_ME_SCREEN_SERVICES 10

@implementation MeScreenServices

+(AFHTTPRequestOperationManager*)sharedManager{
    AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://ws.9hug.com/api/"]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL_ME_SCREEN_SERVICES];
    }
    return manager;
}

+(void)requestByMethod:(NSString*)method widthPath:(NSString*)path withParameters:(NSDictionary*)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableURLRequest *request = [[MeScreenServices sharedManager].requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[MeScreenServices sharedManager].baseURL] absoluteString] parameters:dict error:nil];
    
    AFHTTPRequestOperation *operation =
    [[MeScreenServices sharedManager] HTTPRequestOperationWithRequest:request
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
    [[MeScreenServices sharedManager].operationQueue addOperation:operation];
    
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

+ (void)getUserStatistic:(NSDictionary*)parameters sussess:(SuccessBlock)success failure:(MessageBlock)failure
{
    [[MeScreenServices sharedManager].requestSerializer setTimeoutInterval:30];
    //TODO: change path
    [MeScreenServices requestByMethod:@"GET" widthPath:@"path" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)updateUserStatus:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[MeScreenServices sharedManager].requestSerializer setTimeoutInterval:30];
    //TODO: Change path
    [[MeScreenServices sharedManager] POST:@"path" parameters:dicParam
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

+ (void)getUserStatus:(NSDictionary*)parameters sussess:(SuccessBlock)success failure:(MessageBlock)failure
{
    [[MeScreenServices sharedManager].requestSerializer setTimeoutInterval:30];
    //TODO: change path
    [MeScreenServices requestByMethod:@"GET" widthPath:@"path" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}

@end
