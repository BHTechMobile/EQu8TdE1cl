//
//  StatisticsObject.m
//  9HugMoment
//

#import "StatisticsObject.h"

@implementation StatisticsObject

+ (StatisticsObject *)createStatisticByDictionnary:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    StatisticsObject *statistic = [[StatisticsObject alloc] init];
    
    NSString *numberOfGiftsFromDict      = [dict stringForKey:@"key_gifts"];
    NSString *numberOfRequestsFromDict   = [dict stringForKey:@"key_requests"];
    NSString *numberOfFriendsFromDict    = [dict stringForKey:@"key_friends"];
    NSString *numberOfCreditsFromDict    = [dict stringForKey:@"key_credits"];
    NSString *numberOfStickersFromDict   = [dict stringForKey:@"key_stickers"];
    
    statistic.numberOfGifts     = (numberOfGiftsFromDict != (id)[NSNull null])?numberOfGiftsFromDict:@"";
    statistic.numberOfRequests  = (numberOfRequestsFromDict != (id)[NSNull null])?numberOfRequestsFromDict:@"";
    statistic.numberOfFriends   = (numberOfFriendsFromDict != (id)[NSNull null])?numberOfFriendsFromDict:@"";
    statistic.numberOfCredits   = (numberOfCreditsFromDict!= (id)[NSNull null])?numberOfCreditsFromDict:@"";
    statistic.numberOfStickers  = (numberOfStickersFromDict != (id)[NSNull null])?numberOfStickersFromDict:@"";
    return statistic;
}

@end
