//
//  NSDictionary+Helpers.h
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helpers)

-(id)customObjectForKey:(NSString*)key;

-(NSInteger)intForKey:(NSString*)key;

-(NSString*)stringForKey:(NSString*)key;

+ (NSDictionary *)URLQueryParameters:(NSURL *)URL;
@end
