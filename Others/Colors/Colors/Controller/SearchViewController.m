//
//  SearchViewController.m
//  Colors
//
//  Created by Qilin Hu on 2020/7/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "SearchViewController.h"

// Framework
#import "UIScrollView+EmptyDataSet.h"

// Model
#import "Palette.h"
#import "Color.h"

@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *colorView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *hexLabel;
@property (nonatomic, weak) IBOutlet UILabel *rgbLabel;
@property (nonatomic, weak) IBOutlet UILabel *hexLegend;
@property (nonatomic, weak) IBOutlet UILabel *rgbLegend;

@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, getter=isShowingLandscape) BOOL showingLandscape;

@end

@implementation SearchViewController

#pragma mark - View life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = @"Search";
}

- (void)loadView {
    [super loadView];
    
    if (self.navigationController.viewControllers.count == 1) {
        
    } else {
        self.title = @"Detail";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showingLandscape = UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation);
    
    [self updateContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - Private

- (void)updateContent
{
    BOOL hide = self.selectedColor ? NO : YES;
    
    self.colorView.hidden = hide;
    self.nameLabel.hidden = hide;
    self.hexLabel.hidden = hide;
    self.rgbLabel.hidden = hide;
    self.hexLegend.hidden = hide;
    self.rgbLegend.hidden = hide;
    
    self.colorView.image = [Color roundImageForSize:self.colorView.frame.size withColor:self.selectedColor.color];
    
    self.nameLabel.text = self.selectedColor.name;
    self.hexLabel.text = [NSString stringWithFormat:@"#%@", self.selectedColor.hex];
    self.rgbLabel.text = self.selectedColor.rgb;
}

@end
