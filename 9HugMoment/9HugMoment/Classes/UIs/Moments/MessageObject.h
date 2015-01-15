//
//  MessageObject.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) NSString *agentID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *notification;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *length;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *attachement1;
@property (nonatomic, strong) NSString *attachement2;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *frameID;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *generatedDate;
@property (nonatomic, strong) NSString *createDated;
@property (nonatomic, strong) NSString *scheduled;
@property (nonatomic, strong) NSString *sentDate;
@property (nonatomic, strong) NSString *receiverID;
@property (nonatomic, strong) NSString *receivedDate;
@property (nonatomic, strong) NSString *reads;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *userFacebookID;
@property (nonatomic, strong) NSString *totalVotes;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *voted;

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat ispublic;

@property (nonatomic, assign) BOOL downloaded;

@property (nonatomic, strong) NSMutableArray *votesArray;
@property (nonatomic, strong) NSMutableArray *voicesArray;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *userFacebookIDVoted;

+ (MessageObject *)createMessageByDictionnary:(NSDictionary *)dict;
- (NSString*)localVideoPath;
- (BOOL)isUserVotedMessage;

@end
