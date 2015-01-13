//
//  StatisticsObject.h
//  9HugMoment
//

#import <Foundation/Foundation.h>

@interface StatisticsObject : NSObject

@property (strong, nonatomic) NSString *numberOfGifts;
@property (strong, nonatomic) NSString *numberOfRequests;
@property (strong, nonatomic) NSString *numberOfFriends;
@property (strong, nonatomic) NSString *numberOfCredits;
@property (strong, nonatomic) NSString *numberOfStickers;

+ (StatisticsObject *)createStatisticByDictionnary:(NSDictionary *)dict;

@end
