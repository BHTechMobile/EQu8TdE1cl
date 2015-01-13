//
//  FramesModel.m
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import "FramesModel.h"
#import "Frame.h"

#define FRAME_URL @"https://www.dropbox.com/s/voac1pmksh71kfz/Frames.json?dl=1"

@implementation FramesModel

+ (FramesModel *)sharedFrames
{
    //singleton object
    static FramesModel *object = nil;
    if (!object) {
        object = [[FramesModel alloc] init];
        [object getFrames];
    
    }
    return object;
}

-(void)getFrames{
    NSData* data = nil;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:FRAME_URL]) {
        NSLog(@"Get Frames from cache");
        data = [[[NSUserDefaults standardUserDefaults] objectForKey:FRAME_URL] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else{
        NSLog(@"Get Frames from bundle");
        data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Frames" withExtension:@"json"]];
    }
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSMutableArray * mutableFrames = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        Frame* frame = [Frame frameFromDictionary:dict];
        [mutableFrames addObject:frame];
    }
    _frames = mutableFrames;
    NSLog(@"Cache Frames info:%@",_frames);
    
    [self downloadNewFrames];
}

-(void)downloadNewFrames{
    dispatch_async(dispatch_queue_create("frame_list", NULL), ^{
        NSLog(@"Download Frames from server");
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:FRAME_URL]];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:FRAME_URL];
            
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray * mutableFrames = [NSMutableArray new];
            for (NSDictionary *dict in array) {
                Frame* frame = [Frame frameFromDictionary:dict];
                [mutableFrames addObject:frame];
            }
            _frames = mutableFrames;
            NSLog(@"Downloaded Frames info:%@",_frames);
        }
    });
}

@end
