//
//  MessageDetailsModel.h
//  9HugMoment
//

#import <Foundation/Foundation.h>
#import "ImageCacheObject.h"
#import "CommentObject.h"

@class MessageDetailsModel;
@protocol MessageDetailsModelDelegate <NSObject>
@optional
- (void)didGetMessageDetailSuccess:(MessageDetailsModel *)momentsDetailsModel withMessage:(MessageObject *)messageResponce;
- (void)didGetMessageDetailFailed:(MessageDetailsModel *)momentsDetailsModel withError:(NSError *)error;

- (void)didVoteMessageSuccess:(MessageDetailsModel *)momentsDetailsModel;
- (void)didVoteMessageFailed:(MessageDetailsModel *)momentsDetailsModel;

- (void)didCommentVoiceMessageSuccess:(MessageDetailsModel *)momentsDetailsModel;
- (void)didCommentVoiceMessageFailed:(MessageDetailsModel *)momentsDetailsModel;

- (void)didCommentPhotoMessageSuccess:(MessageDetailsModel *)momentsDetailsModel;
- (void)didCommentPhotoMessageFailed:(MessageDetailsModel *)momentsDetailsModel;

- (void)didCommentTextMessageSuccess:(MessageDetailsModel *)momentsDetailsModel;
- (void)didCommentTextMessageFailed:(MessageDetailsModel *)momentsDetailsModel;
@end

typedef void (^MessageDetailsResponseBlock)(id response, NSError *error);

@interface MessageDetailsModel : NSObject

@property (nonatomic, weak) id<MessageDetailsModelDelegate> delegate;
@property (nonatomic, strong) MessageObject *message;
@property (nonatomic, strong) NSMutableArray *audioCommentObjectArray;
@property (nonatomic, strong) NSMutableArray *pictureCommentObjectArray;

- (void)markCornerRadiusView:(UIView *)view withCornerRadii:(CGSize)cornerRadii;
- (NSString *)getDateTimeByTimeInterval:(double)timeInterval;
- (void)getMessageByKey:(NSString *)keyMessage;
- (void)uploadAudioMessage:(MessageDetailsResponseBlock)finished;
- (void)uploadPhotoMessage:(MessageDetailsResponseBlock)finished;
- (void)voteMessage;
- (void)commentVoiceMessage:(NSString *)mediaLink;
- (void)commentPhotoMessage:(NSString *)mediaLink;
- (void)commentTextMessage:(NSString *)messageString;

+ (void)showSingleAlert:(UIAlertView *)alertView;
+ (BOOL)compareArray:(NSArray *)firstArray withArray:(NSArray *)secondArray;
+ (BOOL)isCurrentUserVoted:(MessageObject *)messageResponce;
- (CGFloat)totalMessageRequest;
+ (void)getUserAvatarWithUserFacebookID:(NSString *)userFacebookID forImageView:(UIImageView *)imageView;
- (void)getAudioCommentFromArray:(NSArray *)audioArray;
- (void)getPictureCommentFromArray:(NSArray *)pictureArray;
+ (NSString *)getCurrentDateAudioWithTimeInterval:(double)timeInterval;

@end
