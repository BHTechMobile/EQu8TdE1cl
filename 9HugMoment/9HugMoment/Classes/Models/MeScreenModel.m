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
//        //TODO: Update user status to UserData
//        if (_delegate && [_delegate respondsToSelector:@selector(didUpdateUserStatusSuccess:)]) {
//            [_delegate performSelector:@selector(didUpdateUserStatusSuccess:) withObject:self];
//        }
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
//        if (_delegate && [_delegate respondsToSelector:@selector(didUpdateUserStatusFail:withError:)]) {
//            [_delegate performSelector:@selector(didUpdateUserStatusFail:withError:) withObject:self withObject:error];
//        }
//    }];
    
    //TODO: Temp need remove
    [UserData currentAccount].strUserStatus = userStatusString;
}

- (void)getUserStatus
{
    //TODO: Waiting for server
//    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
//                               KEY_USER_ID:[UserData currentAccount].strId};
//    [MeScreenServices getUserStatus:dicParam sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //TODO: Update user status to UserData
//        if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatusSuccess:)]) {
//            [_delegate performSelector:@selector(didGetUserStatusSuccess:) withObject:self];
//        }
//    } failure:^(NSString *bodyString, NSError *error) {
//        if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatusFail:withError:)]) {
//            [_delegate performSelector:@selector(didGetUserStatusFail:withError:) withObject:self withObject:error];
//        }
//    }];
    
    //TODO: Temp need remove
    if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatusSuccess:)]) {
        [_delegate performSelector:@selector(didGetUserStatusSuccess:) withObject:self];
    }
}

- (void)getUserStatistics
{
    //TODO: Waiting for server
//    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
//                               KEY_USER_ID:[UserData currentAccount].strId};
//    [MeScreenServices getUserStatistic:dicParam sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatisticsSuccess:)]) {
//            //TODO: Save Statistics to UserData
//            [_delegate performSelector:@selector(didGetUserStatisticsSuccess:) withObject:self];
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
    [UserData currentAccount].strUserNumberOfGifts = [responseStatistics objectForKey:@"key_gifts"];
    [UserData currentAccount].strUserNumberOfRequests = [responseStatistics objectForKey:@"key_requests"];
    [UserData currentAccount].strUserNumberOfFriends = [responseStatistics objectForKey:@"key_friends"];
    [UserData currentAccount].strUserNumberOfCredits = [responseStatistics objectForKey:@"key_credits"];
    [UserData currentAccount].strUserNumberOfStickers = [responseStatistics objectForKey:@"key_stickers"];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didGetUserStatisticsSuccess:)]) {
        [_delegate performSelector:@selector(didGetUserStatisticsSuccess:) withObject:self];
    }
}

- (void)setImageFrameMessage:(UIImageView *)imageView
{
    UIImage *frameMessageImage = [UIImage imageNamed:IMAGE_NAME_ICON_FRAME_MESSAGE];
    UIImage *result = [frameMessageImage resizableImageWithCapInsets:UIEdgeInsetsMake(HALF_OF(frameMessageImage.size.height), HALF_OF(frameMessageImage.size.width), HALF_OF(frameMessageImage.size.height), HALF_OF(frameMessageImage.size.width))];
    
    imageView.image = result;
}

@end
