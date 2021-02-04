//
//  AFViewController.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"

//View
#import "AFCollectionViewCell.h"
#import "AFCollectionViewFlowLayout.h"

//Model
#import "AFPhotoModel.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface AFViewController (Private)

//Private method to set up the model. Treat this like a stub - pay no attention to this method.
-(void)setupModel;

@end

@implementation AFViewController
{
    // 数组模型对象
    NSArray *photoModelArray;
    
    UISegmentedControl *aspectChangeSegmentedControl;
    
    AFCollectionViewFlowLayout *photoCollectionViewLayout;
}

-(void)loadView {
    // 创建自定义布局对象实例
    photoCollectionViewLayout = [[AFCollectionViewFlowLayout alloc] init];
    
    // 创建自定义集合视图
    UICollectionView *photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:photoCollectionViewLayout];
    
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    
    // 注册重用 cell
    [photoCollectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    // Set up the collection view geometry to cover the whole screen in any orientation and other view properties.
    photoCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoCollectionView.allowsSelection = NO; // !!!: 禁用选择
    photoCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    // 添加自定义集合视图
    self.collectionView = photoCollectionView;
    
    // 初始化模型
    [self setupModel];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // 在导航栏上添加自定义 UISegmentedControl 对象
    aspectChangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Aspect Fit", @"Aspect Fill"]];
    aspectChangeSegmentedControl.selectedSegmentIndex = 0;
    [aspectChangeSegmentedControl addTarget:self action:@selector(aspectChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = aspectChangeSegmentedControl;
}

#pragma mark - Private Custom Methods

//A handy method to implement — returns the photo model at any index path
-(AFPhotoModel *)photoModelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item >= [photoModelArray count]) return nil;
    return photoModelArray[indexPath.item];
}

//Configures a cell for a given index path
-(void)configureCell:(AFCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    // Set the image for the cell
    [cell setImage:[[self photoModelForIndexPath:indexPath] image]];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //Return the number of photos in our model array
    return [photoModelArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    // 配置 cell
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

#pragma mark - User Interface Interaction

-(void)aspectChangeSegmentedControlDidChangeValue:(id)sender
{
    // We need to explicitly tell the collection view layout that we want the change animated.
    [UIView animateWithDuration:0.5f animations:^{
        
        // 在两种布局方式之间进行切换
        if (self->photoCollectionViewLayout.layoutMode == AFCollectionViewFlowLayoutModeAspectFill) {
            self->photoCollectionViewLayout.layoutMode = AFCollectionViewFlowLayoutModeAspectFit;
        } else {
            self->photoCollectionViewLayout.layoutMode = AFCollectionViewFlowLayoutModeAspectFill;
        }
    }];
}

@end















@implementation AFViewController (Private)

-(void)setupModel
{    
    photoModelArray = @[
                                         [AFPhotoModel photoModelWithName:@"Purple Flower" image:[UIImage imageNamed:@"0.jpg"]],
                                         [AFPhotoModel photoModelWithName:@"WWDC Hypertable" image:[UIImage imageNamed:@"1.jpg"]],
                                         [AFPhotoModel photoModelWithName:@"Purple Flower II" image:[UIImage imageNamed:@"2.jpg"]],
      [AFPhotoModel photoModelWithName:@"Castle" image:[UIImage imageNamed:@"3.jpg"]],
      [AFPhotoModel photoModelWithName:@"Skyward Look" image:[UIImage imageNamed:@"4.jpg"]],
      [AFPhotoModel photoModelWithName:@"Kakabeka Falls" image:[UIImage imageNamed:@"5.jpg"]],
      [AFPhotoModel photoModelWithName:@"Puppy" image:[UIImage imageNamed:@"6.jpg"]],
      [AFPhotoModel photoModelWithName:@"Thunder Bay Sunset" image:[UIImage imageNamed:@"7.jpg"]],
      [AFPhotoModel photoModelWithName:@"Sunflower I" image:[UIImage imageNamed:@"8.jpg"]],
      [AFPhotoModel photoModelWithName:@"Sunflower II" image:[UIImage imageNamed:@"9.jpg"]],
      [AFPhotoModel photoModelWithName:@"Sunflower I" image:[UIImage imageNamed:@"10.jpg"]],
      [AFPhotoModel photoModelWithName:@"Squirrel" image:[UIImage imageNamed:@"11.jpg"]],
      [AFPhotoModel photoModelWithName:@"Montréal Subway" image:[UIImage imageNamed:@"12.jpg"]],
      [AFPhotoModel photoModelWithName:@"Geometrically Intriguing Flower" image:[UIImage imageNamed:@"13.jpg"]],
      [AFPhotoModel photoModelWithName:@"Grand Lake" image:[UIImage imageNamed:@"17.jpg"]],
      [AFPhotoModel photoModelWithName:@"Spadina Subway Station" image:[UIImage imageNamed:@"15.jpg"]],
      [AFPhotoModel photoModelWithName:@"Staircase to Grey" image:[UIImage imageNamed:@"14.jpg"]],
      [AFPhotoModel photoModelWithName:@"Saint John River" image:[UIImage imageNamed:@"16.jpg"]],
      [AFPhotoModel photoModelWithName:@"Purple Bokeh Flower" image:[UIImage imageNamed:@"18.jpg"]],
      [AFPhotoModel photoModelWithName:@"Puppy II" image:[UIImage imageNamed:@"19.jpg"]],
      [AFPhotoModel photoModelWithName:@"Plant" image:[UIImage imageNamed:@"21.jpg"]],
      [AFPhotoModel photoModelWithName:@"Peggy's Cove I" image:[UIImage imageNamed:@"21.jpg"]],
      [AFPhotoModel photoModelWithName:@"Peggy's Cove II" image:[UIImage imageNamed:@"22.jpg"]],
      [AFPhotoModel photoModelWithName:@"Sneaky Cat" image:[UIImage imageNamed:@"23.jpg"]],
      [AFPhotoModel photoModelWithName:@"King Street West" image:[UIImage imageNamed:@"24.jpg"]],
      [AFPhotoModel photoModelWithName:@"TTC Streetcar" image:[UIImage imageNamed:@"25.jpg"]],
      [AFPhotoModel photoModelWithName:@"UofT at Night" image:[UIImage imageNamed:@"26.jpg"]],
      [AFPhotoModel photoModelWithName:@"Mushroom" image:[UIImage imageNamed:@"27.jpg"]],
      [AFPhotoModel photoModelWithName:@"Montréal Subway Selective Colour" image:[UIImage imageNamed:@"28.jpg"]],
      [AFPhotoModel photoModelWithName:@"On Air" image:[UIImage imageNamed:@"29.jpg"]]];
}

@end

