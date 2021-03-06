//
//  FriendMomentsModel.m
//  9HugMoment
//
//  Created by PhamHuuPhuong on 17/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "FriendMomentsModel.h"
#import "MessageObject.h"

@implementation FriendMomentsModel

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
        if ([dict valueForKey:KEY_AA_DATA] && [[dict valueForKey:KEY_AA_DATA] isKindOfClass:[NSArray class]]) {
            aaData = [dict customObjectForKey:KEY_AA_DATA];
            NSLog(@"aaData in moments model%@",aaData);
            [_messages removeAllObjects];
            for (NSDictionary* mDict in aaData) {
                if ([[mDict valueForKey:KEY_USER_ID] isEqualToString:[UserData currentAccount].strId]) {
                    NSLog(@"your userid");
                }else{
                    MessageObject* message = [MessageObject createMessageByDictionnary:mDict];
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
        }
        else{
            aaData = @[];
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSString *bodyString, NSError *error) {
        NSLog(@"bodyString in moments model %@",bodyString);
        if (failure) {
            failure(error);
        }
    }];
}

@end
