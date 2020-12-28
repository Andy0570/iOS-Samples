//
//  FRPCell.m
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "FRPCell.h"
#import "FRPPhotoModel.h"
#import <NSData+AFDecompression.h>

@interface FRPCell ()
@property (nonatomic , weak ) UIImageView * imageView;
@end

@implementation FRPCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    // Configure self
    self.backgroundColor = [UIColor darkGrayColor];
    
    // Configure subviews
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    /**
     [RACObserve(self, photoModel.thumbnailData) ignore:nil]
     这里的 ignore 和 filter 用法相反，表示如果参数为 nil 就忽略！
     
     self.imageView.image = [UIImage imageWithData:self.photoModel.thumbnailData];
     */
    RAC(self.imageView, image) = [[[RACObserve(self, photoModel.thumbnailData) ignore:nil] map:^id(id value) {
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [value af_decompressedImageFromJPEGDataWithCallback:^(UIImage *decompressedImage) {
                [subscriber sendNext:decompressedImage];
                [subscriber sendCompleted];
            }];
            return nil;
        }] subscribeOn:[RACScheduler scheduler]];
    }] switchToLatest];
    
    [self.rac_prepareForReuseSignal subscribeNext:^(id x) {
        self.imageView.image = nil;
    }];
    
    return self;
}

@end
