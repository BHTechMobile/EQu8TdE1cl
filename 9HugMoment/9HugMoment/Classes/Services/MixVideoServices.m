//
//  MixVideoServices.m
//  9HugMoment
//

#import "MixVideoServices.h"

#define TIME_OUT_INTERVAL_MIX_VIDEO_SERVICES 10

@implementation MixVideoServices

+(AFHTTPRequestOperationManager*)sharedManager{
    AFHTTPRequestOperationManager * manager ;
    if (!manager) {
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://ws.9hug.com/api/"]];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:TIME_OUT_INTERVAL_MIX_VIDEO_SERVICES];
    }
    return manager;
}

+ (void)updateMessage:(NSString*)message
                  key:(NSString*)key
                frame:(NSString*)frame
                 path:(NSURL*)videoPath
             latitude:(NSString*)latitude
            longitude:(NSString *)longitude
         notification:(BOOL)notiF
            scheduled:(NSString*)scheduled
            thumbnail:(UIImage*)image
              sussess:(SuccessBlock)success
              failure:(MessageBlock)failure;
{
    NSDictionary* dict;
    dict = @{@"key":key,
             @"text":message,
             @"frameid":frame,
             @"latitude":latitude,
             @"longitude":longitude,
             @"notification":@(notiF),
             @"scheduled":scheduled,
             @"userid":[[UserData currentAccount] strId]
             };
    
    [[MixVideoServices sharedManager].requestSerializer setTimeoutInterval:300];
    
    AFHTTPRequestOperation* operator = [[MixVideoServices sharedManager] POST:@"message/update" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
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

@end
