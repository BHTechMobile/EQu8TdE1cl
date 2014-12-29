//
//  NSUserDefaults+Helpers.m
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "NSUserDefaults+Helpers.h"

@implementation NSUserDefaults (Helpers)

/**
 *  Save object for key and synchronize
 *
 *  @param object id
 *  @param key    NSString
 *
 *  @return BOOL
 */

+(BOOL)saveObject:(id)object forKey:(NSString *)key{
    [[self standardUserDefaults] setObject:object forKey:key];
    return [[self standardUserDefaults] synchronize];
}

/**
 *  Save int for key and synchronize
 *
 *  @param i   NSInteger
 *  @param key NSString
 *
 *  @return BOOL
 */

+(BOOL)saveInteger:(NSInteger)i forKey:(NSString *)key
{
    [[self standardUserDefaults] setInteger:i forKey:key];
    return [[self standardUserDefaults] synchronize];
}

/**
 *  Save bool for key and synchronize
 *
 *  @param b   BOOL
 *  @param key NSString
 *
 *  @return BOOL
 */

+(BOOL)saveBool:(BOOL)b forKey:(NSString *)key
{
    [[self standardUserDefaults] setBool:b forKey:key];
    return [[self standardUserDefaults] synchronize];
}

/**
 *  Get bool for key
 *
 *  @param key NSString
 *
 *  @return BOOL
 */

+(BOOL)getBoolForKey:(NSString *)key
{
    return [[self standardUserDefaults] boolForKey:key];
}

/**
 *  Get object for key
 *
 *  @param key NSString
 *
 *  @return id
 */

+(id)getObjectForKey:(NSString*)key
{
    return [[self standardUserDefaults] objectForKey:key];
}

/**
 *  Get NSString for key<br>
 *  return @"" if key not exists
 *
 *  @param key NSString
 *
 *  @return NSString
 */

+(NSString *)getStringForKey:(NSString*)key
{
    NSString* string = [self getObjectForKey:key];
    if (string) {
        return [NSString stringWithFormat:@"%@",string];
    }
    return @"";
}

/**
 *  Get int for key
 *
 *  @param key NSString
 *
 *  @return NSInteger
 */

+(NSInteger)getIntegerForKey:(NSString*)key
{
    return [[self standardUserDefaults] integerForKey:key];
}

/**
 *  Remove object for key
 *
 *  @param key BOOL
 */

+(BOOL)removeObjectForKey:(NSString *)key
{
    [[self standardUserDefaults] removeObjectForKey:key];
    return [[self standardUserDefaults] synchronize];
}

+(BOOL)facebookLoggedIn
{
    NSString* token = [NSUserDefaults getObjectForKey:KEY_USER_SETTING_LOGGED_IN_TOKEN];
    if (token == nil) {
        return NO;
    }
    return YES;
}
@end
