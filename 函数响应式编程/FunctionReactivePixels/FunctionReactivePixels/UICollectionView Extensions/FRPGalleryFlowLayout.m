//
//  FRPGalleryFlowLayout.m
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

- (instancetype)init {
    if (!(self = [super init])) { return nil; }
    
    self.itemSize = CGSizeMake(145, 145);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return self;
}

@end
