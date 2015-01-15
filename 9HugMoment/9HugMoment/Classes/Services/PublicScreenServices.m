//
//  PublicScreenServices.m
//  9HugMoment
//

#import "PublicScreenServices.h"

#define TIME_OUT_INTERVAL_ME_SCREEN_SERVICES 10

@implementation PublicScreenServices

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
    NSMutableURLRequest *request = [[PublicScreenServices sharedManager].requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:[PublicScreenServices sharedManager].baseURL] absoluteString] parameters:dict error:nil];
    
    AFHTTPRequestOperation *operation =
    [[PublicScreenServices sharedManager] HTTPRequestOperationWithRequest:request
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
    [[PublicScreenServices sharedManager].operationQueue addOperation:operation];
    
}

+(void)getAllMessageSussess:(SuccessBlock)success failure:(MessageBlock)failure{
    NSDictionary* parameters = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                                 @"idisplaylength":@999,
                                 @"refresh":@1,
                                 @"sent":@0};
    
    [PublicScreenServices requestByMethod:@"GET" widthPath:@"message/browse" withParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

+ (void)responseMessage:(NSDictionary *)dicParam success:(SuccessBlock)success failure:(FailureBlock)failure{
    [[PublicScreenServices sharedManager].requestSerializer setTimeoutInterval:30];
    [[PublicScreenServices sharedManager] POST:@"message/response" parameters:dicParam
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

+ (id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}

@end
