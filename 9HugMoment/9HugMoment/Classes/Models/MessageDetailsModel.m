//
//  MessageDetailsModel.m
//  9HugMoment
//

#import "MessageDetailsModel.h"

@implementation MessageDetailsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioCommentObjectArray = [[NSMutableArray alloc] init];
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


#pragma mark - Custom Methods

- (void)markCornerRadiusView:(UIView *)view withCornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.frame
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.frame;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (void)getUserAvatarWithUserFacebookID:(NSString *)userFacebookID forImageView:(UIImageView *)imageView
{
    UIImage *userAvatar = [[ImageCacheObject shareImageCache].imageCache objectForKey:userFacebookID];
    if (!userAvatar) {
        [BaseServices downloadUserImageWithFacebookID:userFacebookID success:^(AFHTTPRequestOperation *operation, id responseObject){
            imageView.image = responseObject;
            [[ImageCacheObject shareImageCache].imageCache setObject:responseObject forKey:userFacebookID];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            NSLog(@"Error get user image from facebook: %@",error);
        }];
    }else {
        imageView.image = userAvatar;
    }
}

- (NSString *)getDateTimeByTimeInterval:(double)timeInterval
{
    NSString *result = @"";
    NSDate *convertedDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *todayDate = [NSDate date];
    double timeToToday = [convertedDate timeIntervalSinceDate:todayDate];
    timeToToday = -timeToToday;
    
    if (timeToToday < SECONDS_IN_MINUTE)
    {
        result = @"a minute ago";
    }
    else if (timeToToday < (SECONDS_IN_MINUTE * SECONDS_IN_MINUTE))
    {
        int diff = round(timeToToday / SECONDS_IN_MINUTE);
        result = [NSString stringWithFormat:@"%d minutes ago", diff];
    }
    else if (timeToToday < (SECONDS_IN_MINUTE * SECONDS_IN_MINUTE * HOUR_IN_DAY)) {
        int diff = round(timeToToday / SECONDS_IN_MINUTE / SECONDS_IN_MINUTE);
        result = [NSString stringWithFormat:@"%d hours ago", diff];
    }
    else  {
        int diff = round(timeToToday / SECONDS_IN_MINUTE / SECONDS_IN_MINUTE / HOUR_IN_DAY);
        result = [NSString stringWithFormat:@"%d days ago", diff];
    }
    return result;
}

+ (BOOL)compareArray:(NSArray *)firstArray withArray:(NSArray *)secondArray
{
    BOOL arraysContainTheSameObjects = YES;
    NSEnumerator *otherEnum = [secondArray objectEnumerator];
    for (id myObject in firstArray) {
        if (myObject != [otherEnum nextObject]) {
            //We have found a pair of two different objects.
            arraysContainTheSameObjects = NO;
            break;
        }
    }
    return arraysContainTheSameObjects;
}

#pragma mark - Up Vote management

+ (BOOL)isCurrentUserVoted:(MessageObject *)messageResponce
{
    BOOL result = NO;
    int numberOfCurrentUserVote = 0;
    if ((messageResponce.votesArray != (id)[NSNull null]) && [messageResponce.votesArray isKindOfClass:[NSArray class]] )
    {
        for (NSDictionary *dict in messageResponce.votesArray)
        {
            NSString *userFacebookID = [dict objectForKey:KEY_FACEBOOK_ID];
            if ([userFacebookID isEqualToString:[UserData currentAccount].strFacebookId]) {
                numberOfCurrentUserVote ++;
            }
        }
    }
    result = REMAINDERS_OF_TWO(numberOfCurrentUserVote)?YES:NO;
    return result;
}

#pragma mark - Message Management

- (CGFloat)totalMessageRequest
{
    CGFloat result = 0;
    if ((_message.voicesArray != (id)[NSNull null]) && ([_message.voicesArray isKindOfClass:[NSArray class]])) {
        result += _message.voicesArray.count;
    }
    if ((_message.photosArray != (id)[NSNull null]) && ([_message.photosArray isKindOfClass:[NSArray class]])) {
        result += _message.photosArray.count;
    }
    return result;
}

- (void)getAudioCommentFromArray:(NSArray *)audioArray
{
    if (!_audioCommentObjectArray) {
        _audioCommentObjectArray = [[NSMutableArray alloc] init];
    }
    [_audioCommentObjectArray removeAllObjects];
    if ((audioArray != (id)[NSNull null]) && ([audioArray isKindOfClass:[NSArray class]])) {
        for (NSDictionary *dict in audioArray) {
            CommentObject *commentObject = [CommentObject createCommentByDictionnary:dict];
            [_audioCommentObjectArray addObject:commentObject];
        }
    }
}

- (void)getPictureCommentFromArray:(NSArray *)pictureArray
{
    if (!_pictureCommentObjectArray) {
        _pictureCommentObjectArray = [[NSMutableArray alloc] init];
    }
    [_pictureCommentObjectArray removeAllObjects];
    if ((pictureArray != (id)[NSNull null]) && ([pictureArray isKindOfClass:[NSArray class]])) {
        for (NSDictionary *dict in pictureArray) {
            CommentObject *commentObject = [CommentObject createCommentByDictionnary:dict];
            [_pictureCommentObjectArray addObject:commentObject];
        }
    }
}

+ (NSString *)getCurrentDateAudioWithTimeInterval:(double)timeInterval
{
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"hh:mm a"];
    return [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

#pragma mark - Alert
__strong static UIAlertView *singleAlert;

/**
 Shows alert view only if there is ho anoters shown alert
 @param alertView
 Alert to show.
 */
+ (void)showSingleAlert:(UIAlertView *)alertView {
    if (singleAlert.visible) {
        [singleAlert dismissWithClickedButtonIndex:0 animated:NO];
        singleAlert = nil;
    }
    singleAlert = alertView;
    [singleAlert show];
}

@end
