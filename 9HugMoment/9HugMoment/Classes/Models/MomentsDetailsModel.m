//
//  MomentsDetailsModel.m
//  9HugMoment
//

#import "MomentsDetailsModel.h"
#import "MessageObject.h"

@implementation MomentsDetailsModel

- (id)init
{
    self = [super init];
    if(self){
        _userFacebookIDVoted = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getMessageByKey:(NSString *)keyMessage {
    [BaseServices getMessageByKey:keyMessage sussess:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didGetMessageDetailSuccess:withMessage:)]) {
            [_delegate performSelector:@selector(didGetMessageDetailSuccess:withMessage:) withObject:self withObject:[MessageObject createMessageByDictionnary:responseObject]];
        }
    }failure:^(NSString *bodyString, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didGetMessageDetailFailed:withError:)]) {
            [_delegate performSelector:@selector(didGetMessageDetailFailed:withError:) withObject:self withObject:error];
        }
    }];
}

- (void)voteMessage {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypeVote],
                               KEY_MESSAGE_STRING:@"message for vote",
                               KEY_MEDIA_LINK:@"media link for vote",
                               KEY_USER_ID:[UserData currentAccount].strId
                               };
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didVoteMessageSuccess:)]) {
            [_delegate performSelector:@selector(didVoteMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didVoteMessageFailed:)]) {
            [_delegate performSelector:@selector(didVoteMessageFailed:) withObject:self];
        }
    }];
}

- (void)commentVoiceMessage:(NSString *)mediaLink {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypeVoice],
                               KEY_MESSAGE_STRING:@"",
                               KEY_MEDIA_LINK:mediaLink,
                               KEY_USER_ID:[UserData currentAccount].strId};
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentVoiceMessageSuccess:)]) {
            [_delegate performSelector:@selector(didCommentVoiceMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentVoiceMessageFailed:)]) {
            [_delegate performSelector:@selector(didCommentVoiceMessageFailed:) withObject:self];
        }
    }];
}

- (void)commentPhotoMessage:(NSString *)mediaLink {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypePhoto],
                               KEY_MESSAGE_STRING:@"",
                               KEY_MEDIA_LINK:mediaLink,
                               KEY_USER_ID:[UserData currentAccount].strId};
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentPhotoMessageSuccess:)]) {
            [_delegate performSelector:@selector(didCommentPhotoMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentPhotoMessageFailed:)]) {
            [_delegate performSelector:@selector(didCommentPhotoMessageFailed:) withObject:self];
        }
    }];
}

- (void)commentTextMessage:(NSString *)messageString {
    NSDictionary *dicParam = @{KEY_TOKEN:[UserData currentAccount].strUserToken,
                               KEY_MESSAGE_ID:_message.messageID,
                               KEY_TYPE:[NSString stringWithFormat:@"%d",(int)MessageTypeComment],
                               KEY_MESSAGE_STRING:messageString,
                               KEY_MEDIA_LINK:@"",
                               KEY_USER_ID:[UserData currentAccount].strId};
    [BaseServices responseMessage:dicParam success:^(AFHTTPRequestOperation *operation, id responseObject){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentTextMessageSuccess:)]) {
            [_delegate performSelector:@selector(didCommentTextMessageSuccess:) withObject:self];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if (_delegate && [_delegate respondsToSelector:@selector(didCommentTextMessageFailed:)]) {
            [_delegate performSelector:@selector(didCommentTextMessageFailed:) withObject:self];
        }
    }];
}

#pragma mark - Up Vote management
- (NSString *)getNumberOfVoteWithMessage:(MessageObject *)messageResponce
{
    int numberOfVote = 0;
    NSMutableDictionary *allUserVoteDict = [[NSMutableDictionary alloc] init];
    @try {
        [_userFacebookIDVoted removeAllObjects];
        for (NSDictionary *dict in messageResponce.votesArray) {
            NSString *currentUserID = [dict objectForKey:KEY_FACEBOOK_ID];
            if((currentUserID) && (![currentUserID isEqual: @""]))
            {
                int totalTimesUserVote = [[allUserVoteDict objectForKey:currentUserID] intValue];
                totalTimesUserVote++;
                NSNumber *timesUserVote = [[NSNumber alloc] initWithInt:totalTimesUserVote];
                [allUserVoteDict setValue:timesUserVote forKey:currentUserID];
            }
        }
        for (NSString *userIDKey in allUserVoteDict) {
            NSNumber *timesVoteOfCurrentUser = [allUserVoteDict objectForKey:userIDKey];
            if ([timesVoteOfCurrentUser intValue] % 2 != 0) {
                [_userFacebookIDVoted addObject:userIDKey];
            }
        }
        numberOfVote = (int)_userFacebookIDVoted.count;
    }
    @catch (NSException *exception) {
        numberOfVote = 0;
    }
    return [NSString stringWithFormat:@"%d",(int)numberOfVote];
}

- (BOOL)isUserVotedWithUserID:(NSString *)userID
{
    for (NSString *userIDFromArray in _userFacebookIDVoted) {
        if ([userID isEqualToString:userIDFromArray]) {
            return YES;
        }
    }
    return NO;
}

@end
