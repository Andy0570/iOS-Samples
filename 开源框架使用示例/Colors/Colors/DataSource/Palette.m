//
//  Palette.m
//  Colors
//
//  Created by Qilin Hu on 2020/7/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "Palette.h"
#import "Color.h"

static Palette *_sharedPalette = nil;

@implementation Palette

#pragma mark - Initialize

+ (instancetype)sharedPalette {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPalette = [[self alloc] init];
        [_sharedPalette loadColors];
    });
    return _sharedPalette;
}

#pragma mark - Public

- (void)reloadAll {
    [self removeAll];
    [self loadColors];
}

- (void)removeColor:(Color *)color {
    NSInteger idx = [_colors indexOfObject:color];
    
    if (idx >=0 && idx < _colors.count) {
        [_colors removeObjectAtIndex:idx];
    }
}

- (void)removeAll {
    [_colors removeAllObjects];
    _colors = nil;
}

#pragma mark - Private

- (void)loadColors {
    // A list of crayola colors in JSON by Jjdelc https://gist.github.com/jjdelc/1868136
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];

    // colors.json -> Array
    NSArray *objects = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];

    // Array -> Object
    _colors = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for (NSDictionary *dictionary in objects) {
        Color *color = [[Color alloc] initWithDictionary:dictionary];
        [_colors addObject:color];
    }
}

@end
