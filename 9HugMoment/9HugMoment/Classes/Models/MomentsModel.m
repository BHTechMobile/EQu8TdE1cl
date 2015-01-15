//
//  MomentsModel.m
//  9HugMoment
//

#import "MomentsModel.h"
#import "MessageObject.h"

@implementation MomentsModel

#pragma mark - MomentsModel management

- (id)init
{
    self = [super init];
    if(self){
        _messagesHot = [NSMutableArray array];
        _messagesNewest = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - MomentsModel Services

- (void)getAllMessagesSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure
{
    [BaseServices getAllMessageSussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        
        NSArray* aaData;
        if ([dict valueForKey:@"aaData"] && [[dict valueForKey:@"aaData"] isKindOfClass:[NSArray class]]) {
            aaData = [dict customObjectForKey:@"aaData"];
        }
        else{
            aaData = @[];
        }
        NSLog(@"%@",aaData);
        [self getMessageFromArray:aaData];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSString *bodyString, NSError *error) {
        NSLog(@"%@",bodyString);
        if (failure) {
            failure(error);
        }
    }];
}

- (void)resetMessages:(MessageObject *)message Success:(void (^)(id result))success
              failure:(void (^)(NSError *error))failure
{
    [BaseServices resetMessage:message Sussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [BaseServices getAllMessageSussess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSString *bodyString, NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } failure:^(NSString *bodyString, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Custom Methods

- (void)getMessageFromArray:(NSArray *)responseMessage
{
    [_messagesNewest removeAllObjects];
    [_messagesHot removeAllObjects];
    
    // Bring data to array
    for (NSDictionary* mDict in responseMessage) {
        MessageObject* message = [MessageObject createMessageByDictionnary:mDict];
        if (message.ispublic || [message.userID isEqualToString:[UserData currentAccount].strId]) {
            [_messagesNewest addObject:message];
            [_messagesHot addObject:message];
        }
    }
    
    // Sort data - Message Newest
    for (int i =0; i<_messagesNewest.count-1; ++i) {
        for (int j=i+1; j<_messagesNewest.count; ++j) {
            if (((MessageObject*)_messagesNewest[i]).createDated.integerValue < ((MessageObject*)_messagesNewest[j]).createDated.integerValue) {
                [_messagesNewest exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
    // Sort data - Message Hot
    for (int i =0; i < _messagesHot.count-1; ++i) {
        for (int j= i+1; j<_messagesHot.count; ++j) {
            if (((MessageObject*)_messagesHot[i]).totalVotes.integerValue < ((MessageObject*)_messagesHot[j]).totalVotes.integerValue) {
                [_messagesHot exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    // 2nd Sort Message hot - sort with vote and second is create date
    for (int i = 0; i < _messagesHot.count - 1; i++)
    {
        for (int j= i+1; j<_messagesHot.count; ++j) {
            if (((MessageObject*)_messagesHot[i]).totalVotes.integerValue == ((MessageObject*)_messagesHot[j]).totalVotes.integerValue) {
                if (((MessageObject*)_messagesNewest[i]).createDated.integerValue < ((MessageObject*)_messagesNewest[j]).createDated.integerValue) {
                    [_messagesNewest exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }else{
                break;
            }
        }
    }
}

@end
