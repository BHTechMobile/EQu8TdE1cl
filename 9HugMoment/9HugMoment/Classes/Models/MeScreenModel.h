//
//  MeScreenModel.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@class MeScreenModel;
@protocol MeScreenModelDelegate <NSObject>
@optional
- (void)didUpdateUserStatusSuccess:(MeScreenModel *)meScreenModel;
- (void)didUpdateUserStatusFail:(MeScreenModel *)meScreenModel withError:(NSError *)error;

- (void)didGetUserStatusSuccess:(MeScreenModel *)meScreenModel;
- (void)didGetUserStatusFail:(MeScreenModel *)meScreenModel withError:(NSError *)error;

- (void)didGetUserStatisticsSuccess:(MeScreenModel *)meScreenModel;
- (void)didGetUserStatisticsFail:(MeScreenModel *)meScreenModel withError:(NSError *)error;

@end

@interface MeScreenModel : NSObject

@property (weak, nonatomic) id<MeScreenModelDelegate> delegate;

+ (void)getUserAvatarWithUserFacebookID:(NSString *)userFacebookID forImageView:(UIImageView *)imageView;

- (void)getUserStatus;
- (void)updateUserStatus:(NSString *)userStatusString;
- (void)getUserStatistics;

@end
