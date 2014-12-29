//
//  NSDate+Helpers.h
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

+ (NSDate*)dateFromTimeInterval:(NSString*)timeString;

+ (NSDate *)dateFromString:(NSString *)_stringDate format:(NSString *)_dateFormat;

- (NSString *)stringDateWithFormat:(NSString *)_format;

- (NSDateComponents *)getDateComponents;

- (BOOL)isToDay;

- (NSDate*)adjustZeroClock;

+ (NSString *)stringFromDate:(NSDate *)date;

- (NSString*)timeAgoString;
@end
