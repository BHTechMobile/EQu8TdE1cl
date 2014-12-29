//
//  UIColor+Helpers.h
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface UIColor (Helpers)

+(UIColor *)colorWithHex:(int)hex;
+(UIColor*)colorWithHex:(uint)hexValue andAlpha:(float)alpha;

@end
