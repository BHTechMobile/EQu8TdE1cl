//
//  NSDictionary+Helpers.m
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//
#import "NSDictionary+Helpers.h"

@implementation NSDictionary (Helpers)

/**
 *  Check hey exists
 *
 *  @param key NSString
 *
 *  @return BOOL
 */

-(BOOL)hasProperty:(NSString*)key
{
    id object = [self objectForKey:key];
    
    if (object == nil)
    {
        return NO;
    }
    
    return YES;
}

/**
 *  Get object for key
 *
 *  @param key NSString
 *
 *  @return id
 */

-(id)customObjectForKey:(NSString*)key
{
    id object = [self objectForKey:key];
    
    if (object == nil || object == NULL || object == [NSNull null])
    {
        return nil;
    }
    
    return object;
}

/**
 *  Get NSString for Key<br>
 *  return @"" if key not exists
 *
 *  @param key NSString
 *
 *  @return NSString
 */

-(NSString*)stringForKey:(NSString*)key
{
    id object = [self customObjectForKey:key];
    
    if (!object)
    {
        return @"";
    }
    
    return object;
}

/**
 *  Get int for key<br>
 *  return 0 if key not exists
 *
 *  @param key NSString
 *
 *  @return NSInteger
 */

-(NSInteger)intForKey:(NSString*)key
{
    
    id object = [self customObjectForKey:key];
    
    if (object == nil)
    {
        return 0;
    }
    
    return [object intValue];
}

/**
 *  Parse query parameters in URL
 *
 *  @param URL NSURL
 *
 *  @return NSDictionary
 */

+ (NSDictionary *)URLQueryParameters:(NSURL *)URL {
    NSString *queryString = [URL query];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *parameters = [queryString componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameters)
    {
        NSArray *parts = [parameter componentsSeparatedByString:@"="];
        NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([parts count] > 1)
        {
            id value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [result setObject:value forKey:key];
        } else {
            [result setObject:@"" forKey:key];
        }
    }
    return result;
}

@end
