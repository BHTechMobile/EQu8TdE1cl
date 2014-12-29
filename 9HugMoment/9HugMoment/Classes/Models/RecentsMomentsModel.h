//
//  RecentsMomentsModel.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 17/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentsMomentsModel : NSObject

@property (nonatomic,strong) NSMutableArray *messages;

- (void)getAllMessagesSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;

@end
