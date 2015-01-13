//
//  MeScreenModel.m
//  9HugMoment
//

#import "MeScreenModel.h"
#import "ImageCacheObject.h"
#import "MeScreenServices.h"

@implementation MeScreenModel

- (instancetype)init
{
    self = [super init];
    if(self){
        //TODO: Do something.
    }
    return self;
}

+ (void)getUserAvatarWithUserFacebookID:(NSString *)userFacebookID forImageView:(UIImageView *)imageView
{
    UIImage *userAvatar = [[ImageCacheObject shareImageCache].imageCache objectForKey:userFacebookID];
    if (!userAvatar) {
        [MeScreenServices downloadUserImageWithFacebookID:userFacebookID success:^(AFHTTPRequestOperation *operation, id responseObject){
            imageView.image = responseObject;
            [[ImageCacheObject shareImageCache].imageCache setObject:responseObject forKey:userFacebookID];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error get user image from facebook: %@",error);
        }];
    }else {
        imageView.image = userAvatar;
    }
}

- (void)updateUserStatus:(NSString *)userStatusString {
    //TODO: Waiting for server
//    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
//                               @"key_status":userStatusString,
//                               KEY_USER_ID:[UserData currentAccount].strId};
//    [MeScreenServices updateUserStatus:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
//        if (_delegate && [_delegate respondsToSelector:@selector(didUpdateUserStatusSuccess:)]) {
//            [_delegate performSelector:@selector(didUpdateUserStatusSuccess:) withObject:self];
//        }
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        if (_delegate && [_delegate respondsToSelector:@selector(didUpdateUserStatusFail:withError:)]) {
//            [_delegate performSelector:@selector(didUpdateUserStatusFail:withError:) withObject:self withObject:error];
//        }
//    }];
    
    //TODO: Temp need remove
    [[NSUserDefaults standardUserDefaults] setObject:userStatusString forKey:@"STATUS_TEMP"];
}

- (void)getUserStatus
{
    //TODO: Waiting for server
//    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
//                               KEY_USER_ID:[UserData currentAccount].strId};
//    [MeScreenServices getUserStatus:dicParam sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatusSuccess:withStatus:)]) {
//            [_delegate performSelector:@selector(didGetUserStatusSuccess:withStatus:) withObject:self withObject:responseObject];
//        }
//    } failure:^(NSString *bodyString, NSError *error) {
//        if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatusFail:withError:)]) {
//            [_delegate performSelector:@selector(didGetUserStatusFail:withError:) withObject:self withObject:error];
//        }
//    }];
    
    //TODO: Temp need remove
    NSString *responseStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"STATUS_TEMP"];
    if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatusSuccess:withStatus:)]) {
        [_delegate performSelector:@selector(didGetUserStatusSuccess:withStatus:) withObject:self withObject:responseStatus];
    }
}

- (void)getUserStatistics
{
    //TODO: Waiting for server
//    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
//                               KEY_USER_ID:[UserData currentAccount].strId};
//    [MeScreenServices getUserStatistic:dicParam sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatisticsSuccess:withDict:)]) {
//            StatisticsObject *statisticsObject = [StatisticsObject createStatisticByDictionnary:responseObject];
//            [_delegate performSelector:@selector(didGetUserStatisticsSuccess:withDict:) withObject:self withObject:statisticsObject];
//        }
//    } failure:^(NSString *bodyString, NSError *error) {
//        if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatisticsFail:withError:)]) {
//            [_delegate performSelector:@selector(didGetUserStatisticsFail:withError:) withObject:self withObject:error];
//        }
//    }];
    
    //TODO: Temp need remove
    NSDictionary *responseStatistics = @{@"key_gifts":@"99",
                                         @"key_requests":@"0",
                                         @"key_friends":@"888",
                                         @"key_credits":@"1234",
                                         @"key_stickers":@"123"};
    
    if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatisticsSuccess:withDict:)]) {
        StatisticsObject *statisticsObject = [StatisticsObject createStatisticByDictionnary:responseStatistics];
        [_delegate performSelector:@selector(didGetUserStatisticsSuccess:withDict:) withObject:self withObject:statisticsObject];
    }
}

@end
