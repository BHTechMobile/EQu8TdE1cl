//
//  UIAlertView+Helpers.m
//  Miruzo
//
//  Created by setacinq on 4/8/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "UIAlertView+Helpers.h"

@implementation UIAlertView (Helpers)

/**
 *  Show alert view with message<br>
 *  Title default @"Mirozow"
 *
 *  @param message NSString
 */

+(void)showMessage:(NSString*)message
{
    [UIAlertView showTitle:@"" message:message];
}

/**
 *  Show alert view error ([error localizedDescription])
 *
 *  @param error NSError
 */

+(void)showError:(NSError*)error
{
    if (error.code == NSURLErrorCancelled) {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    [UIAlertView showTitle:@"Error" message:[error localizedDescription]];
}

/**
 *  Show alert view with title and message
 *
 *  @param title   NSString
 *  @param message NSString
 */

+(void)showTitle:(NSString*)title message:(NSString*)message
{
    [UIAlertView showTitle:title message:message cancelButtonTitle:@"OK" yesButtonTitle:nil];
}

/**
 *  Show alert view with
 *
 *  @param title             NSString
 *  @param message           NSString
 *  @param cancelButtonTitle NSString
 *  @param yesButtonTitle    NSString
 */

+(void)showTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle yesButtonTitle:(NSString*)yesButtonTitle
{
    if ([cancelButtonTitle isEqualToString:@""]) {
        cancelButtonTitle = nil;
    }
    
    if ([yesButtonTitle isEqualToString:@""]) {
        yesButtonTitle = nil;
    }
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:yesButtonTitle, nil] show];
}
@end
