//
//  MyMomentsModel.m
//  9HugMoment
//
//  Created by PhamHuuPhuong on 15/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import "MyMomentsModel.h"
#import "MessageObject.h"
#import "MomentsMessageTableViewCell.h"

@implementation MyMomentsModel

- (id)init
{
    self = [super init];
    if(self){
        _messages = [NSMutableArray array];
    }
    return self;
}

- (void)getMyMessagesSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure
{
    [BaseServices getMyMessageSussess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dict = (NSDictionary*)responseObject;
        
        NSArray* aaData;
        if ([dict valueForKey:@"aaData"] && [[dict valueForKey:@"aaData"] isKindOfClass:[NSArray class]]) {
            aaData = [dict customObjectForKey:@"aaData"];
            
            NSLog(@"aaData %@",aaData);
            [_messages removeAllObjects];
            for (NSDictionary* mDict in aaData) {
                MessageObject* message = [MessageObject createMessageByDictionnary:mDict];
                [_messages addObject:message];
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
        NSLog(@"bodyString %@",bodyString);
        if (failure) {
            failure(error);
        }
    }];
}

@end
