//
//  CommentObject.m
//  9HugMoment
//

#import "CommentObject.h"

@implementation CommentObject

+ (CommentObject *)createCommentByDictionnary:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    CommentObject *message = [[CommentObject alloc] init];
    
    NSString *commentIDFromDict = [dict stringForKey:KEY_ID];
    NSString *messageIDFromDict = [dict stringForKey:KEY_MESSAGE_ID];
    NSString *typeFromDict      = [dict stringForKey:KEY_TYPE];
    NSString *userIDFromDict    = [dict stringForKey:KEY_USER_ID];
    NSString *messageFromDict   = [dict stringForKey:KEY_MESSAGE_STRING];
    NSString *mediaLinkFromDict = [dict stringForKey:KEY_MEDIA_LINK];
    NSString *sentDateFromDict  = [dict stringForKey:KEY_SENT_DATE_2];
    NSString *fullNameFromDict  = [dict stringForKey:KEY_FULL_NAME];
    NSString *facebookIDFromDict= [dict stringForKey:KEY_FACEBOOK_ID];
    
    message.commentID   = (commentIDFromDict != (id)[NSNull null])?commentIDFromDict:@"";
    message.messageID   = (messageIDFromDict != (id)[NSNull null])?messageIDFromDict:@"";
    message.type        = (typeFromDict != (id)[NSNull null])?typeFromDict:@"";
    message.userID      = (userIDFromDict!= (id)[NSNull null])?userIDFromDict:@"";
    message.message     = (messageFromDict != (id)[NSNull null])?messageFromDict:@"";
    message.mediaLink   = (mediaLinkFromDict != (id)[NSNull null])?mediaLinkFromDict:@"";
    message.sentDate    = (sentDateFromDict != (id)[NSNull null])?sentDateFromDict:@"";
    message.fullName    = (fullNameFromDict != (id)[NSNull null])?fullNameFromDict:@"";
    message.facebookID  = (facebookIDFromDict != (id)[NSNull null])?facebookIDFromDict:@"";
    return message;
}


@end
