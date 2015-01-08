//
//  CommentObject.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@interface CommentObject : NSObject

@property (nonatomic, strong) NSString *commentID;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *mediaLink;
@property (nonatomic, strong) NSString *sentDate;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *facebookID;

+ (CommentObject *)createCommentByDictionnary:(NSDictionary *)dict;

@end
