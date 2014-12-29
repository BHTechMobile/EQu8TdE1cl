//
//  NSString+Helpers.h
//  VBlog
//
//  Created by Quang Mai Van on 11/29/13.
//  Copyright (c) 2013 CNC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

- (BOOL)isEmpty;
- (BOOL)isNilOrEmpty;
+(NSString *)generateRandomString:(int)len;

@end
