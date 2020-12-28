//
//  FRPPhotoDetailViewController.h
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import <UIKit/UIKit.h>

@class FRPPhotoDetailViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface FRPPhotoDetailViewController : UIViewController

- (instancetype)initWithViewModel:(FRPPhotoDetailViewModel *)viewModel;

@property (nonatomic, readonly) FRPPhotoDetailViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
