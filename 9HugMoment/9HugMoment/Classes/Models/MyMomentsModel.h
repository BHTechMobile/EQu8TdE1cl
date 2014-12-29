//
//  MyMomentsModel.h
//  9HugMoment
//
//  Created by PhamHuuPhuong on 15/12/14.
//  Copyright (c) 2014 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMomentsModel : NSObject

@property (nonatomic,strong) NSMutableArray *messages;

- (void)getMyMessagesSuccess:(void (^)(id result))success
                      failure:(void (^)(NSError *error))failure;
@end
