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


+(void)loginWithCode:(NSString*)code fullName:(NSString*)fullName fbID:(NSString*)fbid fbToken:(NSString*)fbToken nickname:(NSString*)nickname mobile:(NSString*)mobile email:(NSString*)email password:(NSString*)password success:(SuccessBlock)success failure:(FailureBlock)failure{

    NSDictionary * params  = @{@"code":code,
                            @"fullname":fullName,
                            @"facebookid":fbid,
                            @"facebook_token":fbToken,
                            @"nickname":nickname,
                            @"mobile":mobile,
                            @"email":email,
                            @"password":password
                            };
    NSLog(@"params %@",params);
   //AFHTTPRequestOperation* operator =
 
    
}


#pragma mark - Message Services

+ (void)getMessageByKey:(NSString*)key sussess:(SuccessBlock)success failure:(MessageBlock)failure{
    NSDictionary* parameters = @{@"key":key};
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

#pragma mark - Utilities

+(id)dictionaryFromData:(id)data error:(NSError**)error{
    NSString *string=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string= [string stringByReplacingOccurrencesOfString:@":null" withString:@":\"\""];
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:error];
}


@end
