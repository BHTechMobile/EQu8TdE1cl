//
//  MomentsModel.m
//  9HugMoment
//

#import "MomentsModel.h"
#import "MessageObject.h"

@implementation MomentsModel

- (id)init
{
    self = [super init];
    if(self){
        _messages = [NSMutableArray array];
    }
    return self;
}

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
        [_messages removeAllObjects];
        for (NSDictionary* mDict in aaData) {
            MessageObject* message = [MessageObject createMessageByDictionnary:mDict];
            if (message.ispublic || [message.userID isEqualToString:[UserData currentAccount].strId]) {
                [_messages addObject:message];
            }
        }
        
        for (int i =0; i<_messages.count-1; ++i) {
            for (int j=i+1; j<_messages.count; ++j) {
                if (((MessageObject*)_messages[i]).createDated.integerValue < ((MessageObject*)_messages[j]).createDated.integerValue) {
                    [_messages exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
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

@end
