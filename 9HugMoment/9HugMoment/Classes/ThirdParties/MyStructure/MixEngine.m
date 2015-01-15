//
//  MixEngine.m
//  9hug
//
//  Created by setacinq on 6/30/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "MixEngine.h"

@implementation MixEngine

+(void)mixAudio:(NSURL*)audioUrl
          image:(UIImage*)image
         volume:(CGFloat)audioVolume
  startAtSecond:(CGFloat)second
       videoUrl:(NSURL*)videoUrl
         volume:(CGFloat)videoVolume
completionHandler:(MixResponse)response
{
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSMutableArray *inputParams = [NSMutableArray arrayWithCapacity:2];
    
    if (audioUrl) {
        // add audio
        AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];

        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                       preferredTrackID:kCMPersistentTrackID_Invalid];
        
        
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(second,audioAsset.duration.timescale)/*CMTimeMake(audioAsset.duration.timescale*100, audioAsset.duration.timescale)*/, videoAsset.duration)
                                       ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                        atTime:kCMTimeZero error:nil];
        
        // add volume audio
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTrack];
        [audioInputParams setVolume:audioVolume atTime:kCMTimeZero];
        [inputParams addObject:audioInputParams];
        [audioInputParams setTrackID:[compositionAudioTrack trackID]];

    }
    
    // add audio video
    AVMutableCompositionTrack *compositionAudioVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    if ([videoAsset tracksWithMediaType:AVMediaTypeAudio].count >0) {
        [compositionAudioVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                            ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                             atTime:kCMTimeZero error:nil];
    }
    
    // add volume audio video
    AVMutableAudioMixInputParameters *audioVideoInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioVideoTrack];
    [audioVideoInputParams setVolume:videoVolume atTime:kCMTimeZero];
    [inputParams addObject:audioVideoInputParams];
    [audioVideoInputParams setTrackID:[compositionAudioVideoTrack trackID]];
    
    // add video
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    // add mix volume
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = inputParams;
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetHighestQuality];
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[NSString generateRandomString:8]]];
    NSURL* exportUrl = [NSURL fileURLWithPath:exportPath];
    
    _assetExport.outputFileType = AVFileTypeMPEG4;
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    [_assetExport setAudioMix:audioMix];
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@"Export Status %ld-- %@", (long)_assetExport.status, _assetExport.outputURL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (_assetExport.status)
            {
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCompleted:
                {
                    NSLog(@"Mix Audio completed");
                    [[self class] mixImage:image videoUrl:_assetExport.outputURL completionHandler:^(NSString *output, AVAssetExportSessionStatus status) {
                        response(output,status);
                    }];
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog (@"CANCELED");
                    break;
                }
            }
            
        });
    }];
}

+(void)mixAudio:(NSURL*)audioUrl
         volume:(CGFloat)audioVolume
  startAtSecond:(CGFloat)second
       videoUrl:(NSURL*)videoUrl
         volume:(CGFloat)videoVolume
completionHandler:(MixResponse)response
{
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSMutableArray *inputParams = [NSMutableArray arrayWithCapacity:2];
    
    // add audio
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    [compositionAudioTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(second,audioAsset.duration.timescale)/*CMTimeMake(audioAsset.duration.timescale*100, audioAsset.duration.timescale)*/, videoAsset.duration)
                                   ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    // add volume audio
    AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioTrack];
    [audioInputParams setVolume:audioVolume atTime:kCMTimeZero];
    [inputParams addObject:audioInputParams];
    [audioInputParams setTrackID:[compositionAudioTrack trackID]];
    
    // add audio video
    AVMutableCompositionTrack *compositionAudioVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionAudioVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    // add volume audio video
    AVMutableAudioMixInputParameters *audioVideoInputParams = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:compositionAudioVideoTrack];
    [audioVideoInputParams setVolume:videoVolume atTime:kCMTimeZero];
    [inputParams addObject:audioVideoInputParams];
    [audioVideoInputParams setTrackID:[compositionAudioVideoTrack trackID]];
    
    // add video
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    // add mix volume
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = inputParams;
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetHighestQuality];
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[NSString generateRandomString:8]]];
    NSURL* exportUrl = [NSURL fileURLWithPath:exportPath];
    
    _assetExport.outputFileType = AVFileTypeMPEG4;
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    [_assetExport setAudioMix:audioMix];
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
        
        NSLog(@"Mix audio success %ld-- %@", (long)_assetExport.status, _assetExport.outputURL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (_assetExport.status){
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCompleted:{
                    response(_assetExport.outputURL.absoluteString,_assetExport.status);
                    break;
                }
                case AVAssetExportSessionStatusCancelled:{
                    NSLog (@"CANCELED");
                    break;
                }
            }
        });
    }];
}

+(void)mixImage:(UIImage*)image videoUrl:(NSURL*)videoUrl completionHandler:(MixResponse)response
{
    
    NSString * _pathVideoTmp = videoUrl.path;
    NSString * _pathOutput = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[NSString generateRandomString:8]]];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"%@",_pathOutput);
    NSError * error = nil;
    
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    CMTime clipStartTime = kCMTimeZero;
    //Record Video
    NSURL *videoURL = videoUrl;
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    //Video channel
    AVMutableCompositionTrack *videoCompositionTrack = nil;
    NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    if (tracks.count > 0) {
        videoCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [videoCompositionTrack insertTimeRange:videoTimeRange ofTrack:tracks[0] atTime:clipStartTime error:&error];
    }
    else {
        error = [NSError errorWithDomain:nil code:-1 userInfo:@{NSLocalizedDescriptionKey:@"No video channel for merging."}];
        NSLog(@"error = %@",error);
        //Delete temp video
        [[NSFileManager defaultManager] removeItemAtPath:_pathVideoTmp error:nil];

    }
    
    AVMutableVideoCompositionLayerInstruction *videoInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoCompositionTrack];
    
    tracks = [videoAsset tracksWithMediaType:AVMediaTypeAudio];
    if (tracks.count > 0) {
        AVMutableCompositionTrack *audioCompositionTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioCompositionTrack insertTimeRange:videoTimeRange ofTrack:tracks[0] atTime:clipStartTime error:&error];
    }
    if (error) {
        //Delete temp video
        [[NSFileManager defaultManager] removeItemAtPath:_pathVideoTmp error:nil];
    }
    
    else {
        //Frame
        
        CGRect rect = CGRectMake(0, 0, videoCompositionTrack.naturalSize.width, videoCompositionTrack.naturalSize.height);
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = rect;
        imageLayer.contents = (__bridge id)(image.CGImage);
        imageLayer.bounds = rect;
        imageLayer.opacity = 1.0f;
        imageLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        CALayer *parentLayer = [CALayer layer];
        CALayer *videoLayer = [CALayer layer];
        parentLayer.frame = rect;
        videoLayer.frame = rect;
        videoLayer.opacity = 1.0;
        
        [parentLayer addSublayer:videoLayer];
        [parentLayer addSublayer:imageLayer];
        
        AVMutableVideoComposition *imageComposition = [AVMutableVideoComposition videoComposition];
        imageComposition.renderSize = rect.size;
        imageComposition.frameDuration = CMTimeMake(1, 30);
        imageComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = videoTimeRange;
        
        instruction.layerInstructions = [NSArray arrayWithObject:videoInstruction];
        imageComposition.instructions = [NSArray arrayWithObject:instruction];
        //Export
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName: AVAssetExportPresetHighestQuality /*AVAssetExportPresetHighestQuality*/];
        exporter.outputURL = [NSURL fileURLWithPath:_pathOutput];
        exporter.videoComposition = imageComposition;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (exporter.status)
            {
                NSLog(@"Export Status %ld-- %@", (long)exporter.status, exporter.outputURL);

                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCompleted:
                {
                    response(_pathOutput,exporter.status);
                    break;
                }
                case AVAssetExportSessionStatusCancelled:
                {
                    NSLog (@"CANCELED");
                    break;
                }
            }
            //Delete original video
//            [[NSFileManager defaultManager] removeItemAtPath:_pathVideoTmp error:nil];
        }];
    }
    
}

@end
