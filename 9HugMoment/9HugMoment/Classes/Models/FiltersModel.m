//
//  FiltersModel.m
//  9HugMoment
//
//  Created by Nong Trung Nghia on 1/5/15.
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import "FiltersModel.h"
#import "Filter.h"

#define FILTER_URL @""

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
    dispatch_async(dispatch_queue_create("frame_list", NULL), ^{
        NSLog(@"Download Filters from server");
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:FILTER_URL]];
        if (!data) {
            NSLog(@"Download Filters failed");
            if ([[NSUserDefaults standardUserDefaults] valueForKey:FILTER_URL]) {
                NSLog(@"Get Filters from cache");
                data = [[[NSUserDefaults standardUserDefaults] stringForKey:FILTER_URL] dataUsingEncoding:NSUTF8StringEncoding];
            }
            else{
                NSLog(@"Get Filters from cache");
                data = [NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Filters" withExtension:@"json"]];
            }
        }
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSMutableArray * mutableFrames = [NSMutableArray new];
        for (NSDictionary *dict in array) {
            Filter* filter = [Filter filterFromDictionary:dict];
            [mutableFrames addObject:filter];
        }
        _filters = mutableFrames;
        NSLog(@"Frames info:%@",_filters);
    });
}

@end
