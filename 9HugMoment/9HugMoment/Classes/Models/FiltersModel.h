//
//  FiltersModel.h
//  Copyright (c) 2015 BHTech Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FiltersModel : NSObject

@property (nonatomic,readonly) NSArray* filters;

+ (FiltersModel *)sharedFilters;

@end
