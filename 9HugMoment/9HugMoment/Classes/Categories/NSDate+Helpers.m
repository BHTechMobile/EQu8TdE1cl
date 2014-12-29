//
//  NSDate+Helpers.m
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

/**
 *  Convert TimeInterval to NSDate
 *
 *  @param timeString NSString
 *
 *  @return NSDate
 */

+ (NSDate*)dateFromTimeInterval:(NSString*)timeString
{
    NSTimeInterval time = [timeString doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

/**
 *  Convert NSString to NSDate with format
 *
 *  @param _stringDate NSString
 *  @param _dateFormat NSString
 *
 *  @return NSDate
 */

+ (NSDate *)dateFromString:(NSString *)_stringDate format:(NSString *)_dateFormat
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"JA"]];
	[dateFormatter setDateFormat:_dateFormat];
	NSDate *result = [dateFormatter dateFromString:_stringDate];
	return result;
}

/**
 *  Convert to NSString with format
 *
 *  @param _format NSString
 *
 *  @return NSString
 */

- (NSString *)stringDateWithFormat:(NSString *)_format
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"JA"]];
	[dateFormatter setDateFormat:_format];
	NSString *dateString = [dateFormatter stringFromDate:self];
	return dateString;
}

/**
 *  Get date components
 *
 *  @return NSDateComponents
 */

- (NSDateComponents *)getDateComponents
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:
										NSEraCalendarUnit
										| NSYearCalendarUnit
										| NSMonthCalendarUnit
										| NSDayCalendarUnit
										| NSHourCalendarUnit
										| NSMinuteCalendarUnit
										| NSSecondCalendarUnit
										| NSWeekCalendarUnit
										| NSWeekdayCalendarUnit
										| NSWeekdayOrdinalCalendarUnit
										| NSQuarterCalendarUnit
                                                   fromDate:self
                                        ];
	return dateComponents;
}

/**
 *  Today
 *
 *  @return BOOL
 */

- (BOOL)isToDay
{
	NSDate *now = [NSDate date];
	NSDateComponents *nowComponents = [now getDateComponents];
	NSDateComponents *dateComponents = [self getDateComponents];
	if (dateComponents.year != nowComponents.year) {
		return NO;
	}
	if (dateComponents.month != nowComponents.month) {
		return NO;
	}
	if (dateComponents.day != nowComponents.day) {
		return NO;
	}
	return YES;
}

/**
 *  adjustZeroClock
 *
 *  @return NSDate
 */

- (NSDate*)adjustZeroClock
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
	return [calendar dateFromComponents:components];	
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"JA"]];
	[dateFormatter setDateFormat:@"yyyyMMdd"];
	NSString *dateString = [dateFormatter stringFromDate:date];
	return dateString;
}

- (NSString*)timeAgoString
{
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:
                               NSYearCalendarUnit |
                               NSMonthCalendarUnit |
                               NSDayCalendarUnit |
                               NSHourCalendarUnit |
                               NSMinuteCalendarUnit |
                               NSSecondCalendarUnit
                                           fromDate:self toDate:[NSDate date] options:0];
    
    NSString *timeAgoString = [NSString string];
    if ([comps year] > 0) {
        timeAgoString =
        [NSString stringWithFormat:@"%i years ago", [comps year]];
    }
    else if ([comps month] > 0) {
        timeAgoString =
        [NSString stringWithFormat:@"%i month ago", [comps month]];
    }
    else if ([comps day] > 0) {
        timeAgoString =
        [NSString stringWithFormat:@"%i days ago", [comps day]];
    }
    else if ([comps hour] > 0) {
        timeAgoString =
        [NSString stringWithFormat:@"%i hours ago", [comps hour]];
    }
    else if ([comps minute] > 0) {
        timeAgoString =
        [NSString stringWithFormat:@"%i mins ago", [comps minute]];
    }
    else if ([comps second] > 0) {
        timeAgoString =
        [NSString stringWithFormat:@"%i secs ago", [comps second]];
    }
    return timeAgoString;
}
@end
