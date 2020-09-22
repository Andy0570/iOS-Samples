//
//  AFViewController.m
//  Circle Layout
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"

// Layout
#import "AFCollectionViewCircleLayout.h"
#import "AFCollectionViewFlowLayout.h"

// View
#import "AFCollectionViewCell.h"

//Static identifier for cells
static NSString *CellIdentifier = @"CellIdentifier";

@interface AFViewController ()

@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, strong) AFCollectionViewCircleLayout *circleLayout;
@property (nonatomic, strong) AFCollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UISegmentedControl *layoutChangeSegmentedControl;

@end

@implementation AFViewController

#pragma mark - View Controller Lifecycle

-(void)loadView {
    // 创建布局对象实例
    self.circleLayout = [[AFCollectionViewCircleLayout alloc] init];
    self.flowLayout = [[AFCollectionViewFlowLayout alloc] init];
    
    // 通过刚刚创建的布局对象实例创建集合视图、设置数据源协议和代理协议
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.circleLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // Register our classes so we can use our custom subclassed cell and header
    [collectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    // Set up the collection view geometry to cover the whole screen in any orientation and other view properties.
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Finally, set our collectionView (since we are a collection view controller, this also sets self.view)
    self.collectionView = collectionView;
    
    // Setup our model
    self.cellCount = 12;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem)];
    
    self.layoutChangeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Circle", @"Flow"]];
    self.layoutChangeSegmentedControl.selectedSegmentIndex = 0;
    [self.layoutChangeSegmentedControl addTarget:self action:@selector(layoutChangeSegmentedControlDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.layoutChangeSegmentedControl;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - User Interaction Methods

-(void)layoutChangeSegmentedControlDidChangeValue:(id)sender
{
    // We need to explicitly tell the collection view layout that we want the change animated.
    if (self.collectionView.collectionViewLayout == self.circleLayout)
    {
        [self.flowLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
    } else {
        [self.circleLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.circleLayout animated:YES];
    }
}

#pragma mark - Private Methods

-(void)addItem {
    [self.collectionView performBatchUpdates:^{
        self.cellCount = self.cellCount + 1;
        [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.cellCount-1 inSection:0]]];
    } completion:nil];
}

-(void)deleteItem {
    // Always have at least once cell in our collection view
    if (self.cellCount == 1) return;
    
    [self.collectionView performBatchUpdates:^{
        self.cellCount = self.cellCount - 1;
        [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.cellCount inSection:0]]];
    } completion:nil];
}

#pragma mark - UICollectionView Delegate & DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setLabelString:[NSString stringWithFormat:@"%d", indexPath.row]];
    return cell;
}

#pragma mark - <AFCollectionViewDelegateCircleLayout>

-(CGFloat)rotationAngleForSupplmentaryViewInCircleLayout:(AFCollectionViewCircleLayout *)circleLayout {
    CGFloat timeRatio = 0.0f;
    
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:date];
    timeRatio = (CGFloat)(components.minute) / 60.0f;
    
    return (2 * M_PI * timeRatio);
}

@end
