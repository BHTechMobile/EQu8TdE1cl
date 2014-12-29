//
//  NSUserDefaults+Helpers.h
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Helpers)

+(BOOL)saveObject:(id)object forKey:(NSString *)key;
+(BOOL)saveInteger:(NSInteger)i forKey:(NSString *)key;
+(id)getObjectForKey:(NSString*)key;
+(NSString *)getStringForKey:(NSString*)key;
+(NSInteger)getIntegerForKey:(NSString*)key;
+(BOOL)saveBool:(BOOL)b forKey:(NSString *)key;
+(BOOL)getBoolForKey:(NSString *)key;
+(BOOL)removeObjectForKey:(NSString *)key;
+(BOOL)facebookLoggedIn;
@end
