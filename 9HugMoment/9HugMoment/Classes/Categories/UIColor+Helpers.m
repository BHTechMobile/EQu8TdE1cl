//
//  UIColor+Helpers.m
//  Miruzo
//
//  Created by setacinq on 4/2/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "UIColor+Helpers.h"

@implementation UIColor (Helpers)

/**
 *  Color with Hex<br>
 *  Ex: [UIColor colorWithHex:0x3f84c4]
 *
 *  @param hex int
 *
 *  @return UIColor
 */

+(UIColor *)colorWithHex:(int)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

/**
 *  Color with Hex and alpha
 *
 *  @param hexValue Int
 *  @param alpha    Float (0->1)
 *
 *  @return UIColor
 */

+(UIColor*)colorWithHex:(uint)hexValue andAlpha:(float)alpha {
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0
            alpha:alpha];
}

@end
