
//
//  UIAlertView+Helpers.h
//  Miruzo
//
//  Created by setacinq on 4/8/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Helpers)

+(void)showMessage:(NSString*)message;
+(void)showError:(NSError*)error;
+(void)showTitle:(NSString*)title message:(NSString*)message;
+(void)showTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle yesButtonTitle:(NSString*)yesButtonTitle;
@end
