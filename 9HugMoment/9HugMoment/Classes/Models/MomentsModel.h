//
//  MomentsModel.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@class MomentsModel;
@protocol MomentsModelDelegate <NSObject>
@optional
- (void)didVoteMessageSuccess:(MomentsModel *)momentsDetailsModel;
- (void)didVoteMessageFailed:(MomentsModel *)momentsDetailsModel;

@end

@interface MomentsModel : NSObject

@property (strong, nonatomic) NSMutableArray *messagesHot;
@property (strong, nonatomic) NSMutableArray *messagesNewest;
@property (weak, nonatomic) id<MomentsModelDelegate> delegate;

- (void)getAllMessagesSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;
- (void)resetMessages:(MessageObject *)message Success:(void (^)(id result))success
              failure:(void (^)(NSError *error))failure;
- (void)voteMessage:(MessageObject *)messageObject;

@end
