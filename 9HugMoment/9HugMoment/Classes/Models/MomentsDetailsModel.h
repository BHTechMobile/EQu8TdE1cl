//
//  MomentsDetailsModel.h
//  9HugMoment
//

#import <Foundation/Foundation.h>
@class MomentsDetailsModel;
@protocol MomentsDetailsModelDelegate <NSObject>
@optional
- (void)didGetMessageDetailSuccess:(MomentsDetailsModel *)momentsDetailsModel withMessage:(MessageObject *)messageResponce;
- (void)didGetMessageDetailFailed:(MomentsDetailsModel *)momentsDetailsModel withError:(NSError *)error;

- (void)didVoteMessageSuccess:(MomentsDetailsModel *)momentsDetailsModel;
- (void)didVoteMessageFailed:(MomentsDetailsModel *)momentsDetailsModel;

- (void)didCommentVoiceMessageSuccess:(MomentsDetailsModel *)momentsDetailsModel;
- (void)didCommentVoiceMessageFailed:(MomentsDetailsModel *)momentsDetailsModel;

- (void)didCommentPhotoMessageSuccess:(MomentsDetailsModel *)momentsDetailsModel;
- (void)didCommentPhotoMessageFailed:(MomentsDetailsModel *)momentsDetailsModel;

- (void)didCommentTextMessageSuccess:(MomentsDetailsModel *)momentsDetailsModel;
- (void)didCommentTextMessageFailed:(MomentsDetailsModel *)momentsDetailsModel;
@end

@interface MomentsDetailsModel : NSObject

@property (nonatomic, strong) MessageObject *message;
@property (nonatomic, weak) id<MomentsDetailsModelDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *userFacebookIDVoted;

- (void)getMessageByKey:(NSString *)keyMessage;
- (void)voteMessage;
- (void)commentVoiceMessage:(NSString *)mediaLink;
- (void)commentPhotoMessage:(NSString *)mediaLink;
- (void)commentTextMessage:(NSString *)messageString;
- (NSString *)getNumberOfVoteWithMessage:(MessageObject *)messageResponce;
- (BOOL)isUserVotedWithUserID:(NSString *)userID;

@end
