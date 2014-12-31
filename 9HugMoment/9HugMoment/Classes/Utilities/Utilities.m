//
//  Utilities.m
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Utilities.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
//#import "ProgressHUD.h"

@implementation Utilities
//+ (void) hideTabBar:(UITabBarController *) tabbarcontroller {
//
////    [[appDelegate tabbar] hideNewTabBar];
//    
//    for(UIView *view in [appDelegate tabbar].view.subviews)
//    {
////        if(![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:[UITabBar class]])
////        {
//
//        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, APP_SCREEN_HEIGHT+20)];
////        }
//        
//    }
//    
//}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 3.0f, 3.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIView *)viewSpace :(float)pointX{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(pointX, 0, 1, 8)];
    [view setTag:1000];
    
    [view setBackgroundColor:[UIColor blackColor]];
    return view;
}

+ (void) showTabBar:(UITabBarController *) tabbarcontroller {
//    [[appDelegate tabbar] showNewTabBar];
    
//    for(UIView *view in [appDelegate tabbar].view.subviews)
//    {
//        if(![view isKindOfClass:[UIButton class]] && ![view isKindOfClass:[UIImageView class]] && ![view isKindOfClass:[UITabBar class]])
//        {
//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, APP_SCREEN_HEIGHT+20 - 43)];
//        }
//    }
}

+ (void)setBorderForView:(UIView *)view{
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth =1.0f;
}


+(UIButton*)squareButtonWithSize:(CGFloat)size background:(UIImage*)background text:(NSString*)text target:(id)target selector:(SEL)selector tag:(int)tag isTypeFrame:(BOOL)type{

    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    
    if (background){
        [button setImage:background forState:UIControlStateNormal];
    }
    
    if (text){
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
 
    button.tag = tag;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.imageView.layer.cornerRadius = 10;
    button.layer.cornerRadius = 10;
    if (!type) {
        button.imageView.layer.cornerRadius = 25;
        button.layer.cornerRadius = 25;
        //add
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((CGRectGetHeight(button.frame)-10)/2, (CGRectGetHeight(button.frame)-10)/2, 10, 10)];
        [view setBackgroundColor:[UIColor blackColor]];
        [view.layer setCornerRadius:5];
        [view.layer setMasksToBounds:YES];
        if (tag==0) {
            view.alpha = 0.2;
        }
        //view2
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake((CGRectGetHeight(button.frame)-20)/2, (CGRectGetHeight(button.frame)-20)/2, 20, 20)];
        [view2 setBackgroundColor:[UIColor whiteColor]];
        [view2.layer setCornerRadius:10];
        [view2.layer setMasksToBounds:YES];
        [view2 setAlpha:0.3];
        [button addSubview:view2];
        [button addSubview:view];
    }
    return button;
}

+(void)showAlertViewWithTitle :(NSString *)title andMessage:(NSString *)message andDelegate:(id)delegate{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle: @"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 101;
    [alert show];
}

+ (NSString*)timeFromAudio:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf((value) - (minutes * 60));
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}

//create thumbnail
+ (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToRatio:(CGFloat)ratio
{
    CGFloat width = image.size.width * ratio;
    CGFloat height = image.size.height * ratio;
    CGRect imageRect = CGRectMake(0,0,width,height);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (CGFloat)getTextHeight :(UITextView *)m_pDesTextView
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
    {
        CGRect frame = m_pDesTextView.bounds;
        CGSize fudgeFactor;
        fudgeFactor = CGSizeMake(10.0, 16.0);
        frame.size.height -= fudgeFactor.height;
        frame.size.width -= fudgeFactor.width;
        
        NSMutableAttributedString* textToMeasure;
        if(m_pDesTextView.attributedText && m_pDesTextView.attributedText.length > 0){
            textToMeasure = [[NSMutableAttributedString alloc] initWithAttributedString:m_pDesTextView.attributedText];
        }
        else{
            textToMeasure = [[NSMutableAttributedString alloc] initWithString:m_pDesTextView.text];
            [textToMeasure addAttribute:NSFontAttributeName value:m_pDesTextView.font range:NSMakeRange(0, textToMeasure.length)];
        }
        
        if ([textToMeasure.string hasSuffix:@"\n"])
        {
            [textToMeasure appendAttributedString:[[NSAttributedString alloc] initWithString:@"-" attributes:@{NSFontAttributeName: m_pDesTextView.font}]];
        }
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
        
        return CGRectGetHeight(size) + fudgeFactor.height;
    }
    else
    {
        return m_pDesTextView.contentSize.height+10;
    }
}

+(NSArray *)findFiles:(NSString *)extension{
    
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    // >>> this section here adds all files with the chosen extension to an array
    for (item in contents){
        if ([[item pathExtension] isEqualToString:extension]) {
            [matches addObject:item];
        }
    }
    return matches;
}

#pragma mark Loading View


- (void)iOS6showLoadingViewSuccess {
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self hideLoadingView];
    });
}

- (void)iOS6showLoadingViewError {
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });
}

#pragma mark - progressHUD iOS7
- (void)iOS7showLoadingViewSuccess {

}

- (void)iOS7showLoadingViewError {

}

+ (UIImage *)setThumbnail :(UIImage *)image withSize:(CGSize )destinationSize{
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//+ (void)setImageForButton:(UIButton *)btn andURLImage:(NSString *)strUrl andArrayCaches:(NSMutableArray *)arr{
//    NSURL *imageURL = [NSURL URLWithString:strUrl];
//    NSString *key = [imageURL.absoluteString MD5Hash];
//    NSData *data = [FTWCache objectForKey:key];
//    if (data) {
//        UIImage *image = [UIImage imageWithData:data];
//        [btn setBackgroundImage:image forState:UIControlStateNormal];
//        [arr addObject:image];
//    } else {
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(queue, ^{
//            NSData *data = [NSData dataWithContentsOfURL:imageURL];
//                       [FTWCache setObject:data forKey:key];
//            UIImage *image = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//            [btn setBackgroundImage:image forState:UIControlStateNormal];
//                [arr addObject:image];
//            });
//        });
//    }
//}

//+ (void)setImage :(UIImageView *)imageView andURLImage :(NSString *)strUrl addToArray:(NSMutableArray *)arrCache;{
//    NSURL *imageURL = [NSURL URLWithString:strUrl];
//    NSString *key = [imageURL.absoluteString MD5Hash];
//    NSData *data = [FTWCache objectForKey:key];
//    if (data) {
//        UIImage *image = [UIImage imageWithData:data];
//        [imageView setImage:image];
//        [arrCache addObject:imageView];
//    } else {
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(queue, ^{
//            NSData *data = [NSData dataWithContentsOfURL:imageURL];
//            [FTWCache setObject:data forKey:key];
//            UIImage *image = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [imageView setImage:image];
//                [arrCache addObject:imageView];
//            });
//        });
//    }
//}

+ (NSString *)MD5StringFromString:(NSString*)string {
    const char *cstr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}

+ (void)geocodeLocation:(CLLocation*)location success:(void (^)(NSString* address, CLLocation* requestLocation))success failure:(void(^)(NSError* error))failure{
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    __block CLLocation* blockLocation = location;
    [geocoder reverseGeocodeLocation:blockLocation completionHandler:^(NSArray* placemarks, NSError* error){
        if (error||[placemarks count]==0) {
            if (failure) {
                failure(error);
            }
        }
        else{
            CLPlacemark * placemark = [placemarks firstObject];
            if (success) {
                success([NSString stringWithFormat:@"%@, %@, %@, %@",(placemark.name == nil)?@"":placemark.name,(placemark.thoroughfare == nil)?@"":placemark.thoroughfare,(placemark.locality == nil)?@"":placemark.locality,(placemark.country == nil)?@"":placemark.country],blockLocation);
            }
        }
    }];
}

@end
