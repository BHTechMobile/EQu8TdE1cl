//
//  MomentsModel.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@interface MomentsModel : NSObject

@property (nonatomic,strong) NSMutableArray *messages;

- (void)getAllMessagesSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;
- (void)resetMessages:(MessageObject *)message Success:(void (^)(id result))success
             failure:(void (^)(NSError *error))failure;

@end
