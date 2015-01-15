//
//  MixEngine.h
//  9hug
//
//  Created by setacinq on 6/30/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^MixResponse)(NSString* output,AVAssetExportSessionStatus status);

@interface MixEngine : NSObject

+(void)mixAudio:(NSURL*)audioUrl
          image:(UIImage*)image
         volume:(CGFloat)audioVolume
  startAtSecond:(CGFloat)second
       videoUrl:(NSURL*)videoUrl
         volume:(CGFloat)videoVolume
completionHandler:(MixResponse)response;

+(void)mixAudio:(NSURL*)audioUrl
         volume:(CGFloat)audioVolume
  startAtSecond:(CGFloat)second
       videoUrl:(NSURL*)videoUrl
         volume:(CGFloat)videoVolume
completionHandler:(MixResponse)response;
+(void)mixImage:(UIImage*)image videoUrl:(NSURL*)videoUrl completionHandler:(MixResponse)response;

@end
