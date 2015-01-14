//
//  FiltersModel.m
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import "FiltersModel.h"
#import "Filter.h"

#define FILTER_URL @"https://www.dropbox.com/s/51b4i42zqdbq24k/Filters.json?dl=1"

@implementation FiltersModel
+ (FiltersModel *)sharedFilters
{
    //singleton object
    static FiltersModel *object = nil;
    if (!object) {
        object = [[FiltersModel alloc] init];
        [object getFilters];
    }
    return object;
}

-(void)getFilters{
    NSData* data = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FILTER_URL]) {
        NSLog(@"Get Filters from cache");
        data = [[[NSUserDefaults standardUserDefaults] objectForKey:FILTER_URL] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else{
        NSLog(@"Get Filters from Bundle");
        data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Filters" withExtension:@"json"]];
    }
    
    NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSMutableArray * mutableFrames = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        Filter* filter = [Filter filterFromDictionary:dict];
        [mutableFrames addObject:filter];
    }
    _filters = mutableFrames;
    NSLog(@"Cache Filters info:%@",_filters);
    [self downloadNewContent];
   
}

-(void)downloadNewContent{
    dispatch_async(dispatch_queue_create("frame_list", NULL), ^{
        NSLog(@"Download Filters from server");
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:FILTER_URL]];
        if (data) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:FILTER_URL];
            NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray * mutableFrames = [NSMutableArray new];
            for (NSDictionary *dict in array) {
                Filter* filter = [Filter filterFromDictionary:dict];
                [mutableFrames addObject:filter];
            }
            _filters = mutableFrames;
            NSLog(@"Filters info:%@",_filters);
        }
    });
}

@end
