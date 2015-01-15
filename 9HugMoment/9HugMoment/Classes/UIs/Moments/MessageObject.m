//
//  MessageObject.m
//  9HugMoment
//

#import "MessageObject.h"

@implementation MessageObject

+ (MessageObject *)createMessageByDictionnary:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    MessageObject *message = [[MessageObject alloc] init];
    
    NSString *messageIDFromDict = [dict stringForKey:KEY_ID];
    NSString *agentIDFromDict   = [dict stringForKey:KEY_AGENT_ID];
    NSString *typeFromDict      = [dict stringForKey:KEY_TYPE];
    NSString *notificationFromDict = [dict stringForKey:KEY_NOTIFICATION];
    NSString *keyFromDict       = [dict stringForKey:KEY_KEY];
    NSString *codeFromDict      = [dict stringForKey:KEY_CODE];
    NSString *lengthFromDict    = [dict stringForKey:KEY_LENGTH];
    NSString *thumbFromDict     = [dict stringForKey:KEY_THUMB];
    NSString *attachement1FromDict = [dict stringForKey:KEY_ATTACHEMENT_1];
    NSString *attachement2FromDict = [dict stringForKey:KEY_ATTACHEMENT_2];
    NSString *textFromDict      = [dict stringForKey:KEY_TEXT];
    NSString *userIDFromDict    = [dict stringForKey:KEY_USER_ID];
    NSString *frameIDFromDict   = [dict stringForKey:KEY_FRAME_ID];
    NSString *categoryFromDict  = [dict stringForKey:KEY_CATEGORY];
    NSString *generatedDateFromDict = [dict stringForKey:KEY_GENERATED_DATE];
    NSString *createDatedFromDict   = [dict stringForKey:KEY_CREATE_DATED];
    NSString *scheduledFromDict = [dict stringForKey:KEY_SCHEDULED];
    NSString *sentDateFromDict  = [dict stringForKey:KEY_SENT_DATE];
    NSString *receiverIDFromDict    = [dict stringForKey:KEY_RECEIVER_ID];
    NSString *receivedDateFromDict  = [dict stringForKey:KEY_RECEIVER_DATE];
    NSString *readsFromDict     = [dict stringForKey:KEY_READS];
    NSString *fullNameFromDict  = [dict stringForKey:KEY_FULL_NAME];
    NSString *userFacebookID    = [dict stringForKey:KEY_FACEBOOK_ID];
    NSString *styleFromDict     = [dict stringForKey:KEY_STYLE];
    NSString *votedFromDict     = [dict stringForKey:KEY_VOTED];
    
    NSMutableArray *votesArrayFromDict = (NSMutableArray *)[dict stringForKey:KEY_VOTES];
    NSString *totalVotesFromDict = [dict stringForKey:KEY_TOTAL_VOTES];
    NSMutableArray *voicesArrayFromDict = (NSMutableArray *)[dict stringForKey:KEY_VOICES];
    NSMutableArray *photosArrayFromDict = (NSMutableArray *)[dict stringForKey:KEY_PHOTOS];
    
    message.messageID       = (messageIDFromDict != (id)[NSNull null])?messageIDFromDict:@"";
    message.agentID         = (agentIDFromDict != (id)[NSNull null])?agentIDFromDict:@"";
    message.type            = (typeFromDict != (id)[NSNull null])?typeFromDict:@"";
    message.notification    = (notificationFromDict!= (id)[NSNull null])?notificationFromDict:@"";
    message.key             = (keyFromDict != (id)[NSNull null])?keyFromDict:@"";
    message.code            = (codeFromDict != (id)[NSNull null])?codeFromDict:@"";
    message.length          = (lengthFromDict != (id)[NSNull null])?lengthFromDict:@"";
    message.thumb           = (thumbFromDict != (id)[NSNull null])?thumbFromDict:@"";
    message.attachement1    = (attachement1FromDict != (id)[NSNull null])?attachement1FromDict:@"";
    message.attachement2    = (attachement2FromDict != (id)[NSNull null])?attachement2FromDict:@"";
    message.text            = (textFromDict != (id)[NSNull null])?textFromDict:@"";
    message.userID          = (userIDFromDict != (id)[NSNull null])?userIDFromDict:@"";
    message.frameID         = (frameIDFromDict != (id)[NSNull null])?frameIDFromDict:@"";
    message.category        = (categoryFromDict != (id)[NSNull null])?categoryFromDict:@"";
    message.generatedDate   = (generatedDateFromDict != (id)[NSNull null])?generatedDateFromDict:@"";
    message.createDated     = (createDatedFromDict != (id)[NSNull null])?createDatedFromDict:@"";
    message.scheduled       = (scheduledFromDict!= (id)[NSNull null])?scheduledFromDict:@"";
    message.sentDate        = (sentDateFromDict!= (id)[NSNull null])?sentDateFromDict:@"";
    message.receiverID      = (receiverIDFromDict!= (id)[NSNull null])?receiverIDFromDict:@"";
    message.receivedDate    = (receivedDateFromDict!= (id)[NSNull null])?receivedDateFromDict:@"";
    message.reads           = (readsFromDict!= (id)[NSNull null])?readsFromDict:@"";
    message.fullName        = (fullNameFromDict!= (id)[NSNull null])?fullNameFromDict:@"";
    message.style           = (styleFromDict!= (id)[NSNull null])?styleFromDict:@"";
    message.userFacebookID  = (userFacebookID != (id)[NSNull null])?userFacebookID:@"";
    
    message.latitude        = [[dict valueForKey:KEY_LATITUDE] floatValue];
    message.longitude       = [[dict valueForKey:KEY_LONGITUDE] floatValue];
    message.ispublic        = [[dict valueForKey:KEY_IS_PUBLIC] floatValue];

    message.location        = [dict valueForKey:KEY_LOCATION];
    message.voted           = (votedFromDict != (id)[NSNull null])?votedFromDict:@"";

    message.votesArray      = [[NSMutableArray alloc] init];
    message.voicesArray     = [[NSMutableArray alloc] init];
    message.photosArray     = [[NSMutableArray alloc] init];

    message.votesArray      = (votesArrayFromDict != (id)[NSNull null])?votesArrayFromDict:message.votesArray;
    message.totalVotes      = (totalVotesFromDict != (id)[NSNull null])?totalVotesFromDict:message.totalVotes;
    message.voicesArray     = (voicesArrayFromDict != (id)[NSNull null])?voicesArrayFromDict:message.votesArray;
    message.photosArray     = (photosArrayFromDict != (id)[NSNull null])?photosArrayFromDict:message.votesArray;
    return message;
}

#pragma mark - Custom Methods
- (NSString*)localVideoPath
{
    NSString* fileName = [NSString stringWithFormat:@"Documents/%@.mp4",self.key];
    return [NSHomeDirectory() stringByAppendingPathComponent:fileName];
}

-(BOOL)downloaded{
    NSString* fileName = [NSString stringWithFormat:@"Documents/%@.mp4",self.key];
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:fileName]];
}

- (BOOL)isUserVotedMessage
{
    BOOL result = NO;
    result = [self.voted boolValue];
    return result;
}

@end
