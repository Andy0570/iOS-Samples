//
//  DetailViewController.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/21.
//

#import <UIKit/UIKit.h>
#import "XHStarRateView.h"

@class RWTScaryBugDoc;

NS_ASSUME_NONNULL_BEGIN

/// 详细视图控制器
@interface DetailViewController : UIViewController <UITextFieldDelegate, XHStarRateViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) RWTScaryBugDoc *detailItem;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet XHStarRateView *rateView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) UIImagePickerController *picker;

- (IBAction)addPictureTapped:(id)sender;
- (IBAction)titleFieldTextChanged:(id)sender;

@end

NS_ASSUME_NONNULL_END
