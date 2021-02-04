//
//  AFViewController.m
//  One Hundred Pixels
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"
#import "AFCollectionViewFlowLayout.h"
#import "AFCollectionViewStackedLayout.h"
#import "AFCoverFlowFlowLayout.h"
#import "AFCollectionViewCell.h"
#import "AFCollectionViewHeaderView.h"
#import "AFImageDownloader.h"

enum {
    AFViewControllerPopularSection = 0,
    AFViewControllerEditorsSection,
    AFViewControllerUpcomingSection,
    AFViewControllerNumberSections
};

@interface AFViewController ()

@property (nonatomic, strong) AFCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) AFCollectionViewStackedLayout *stackLayout;
@property (nonatomic, strong) AFCoverFlowFlowLayout *coverFlowLayout;

@property (nonatomic, strong) NSMutableArray *popularPhotos;
@property (nonatomic, strong) NSMutableArray *editorsPhotos;
@property (nonatomic, strong) NSMutableArray *upcomingPhotos;


@end

@implementation AFViewController

#pragma mark - View Controller Lifecycle

//Static identifier for cells
static NSString *CellIdentifier = @"CellIdentifier";
static NSString *HeaderIdentifier = @"HeaderIdentifier";

-(void)loadView
{
    // Create our view
    
    // Create instances of our layouts
    self.stackLayout = [[AFCollectionViewStackedLayout alloc] init];
    self.flowLayout = [[AFCollectionViewFlowLayout alloc] init];
    self.coverFlowLayout = [[AFCoverFlowFlowLayout alloc] init];
    
    // Create a new collection view with our flow layout and set ourself as delegate and data source.
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.stackLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    // Register our classes so we can use our custom subclassed cell and header
    [collectionView registerClass:[AFCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [collectionView registerClass:[AFCollectionViewHeaderView class] forSupplementaryViewOfKind:[AFCollectionViewHeaderView kind] withReuseIdentifier:HeaderIdentifier];
    
    // Set up the collection view geometry to cover the whole screen in any orientation and other view properties.
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Finally, set our collectionView (since we are a collection view controller, this also sets self.view)
    self.collectionView = collectionView;
    
    // Setup our model
    self.popularPhotos = [NSMutableArray arrayWithCapacity:20];
    self.editorsPhotos = [NSMutableArray arrayWithCapacity:20];
    self.upcomingPhotos = [NSMutableArray arrayWithCapacity:20];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    void (^block)(NSDictionary *, NSError *) = ^(NSDictionary *results, NSError *error) {
        
        NSMutableArray *array;
        NSInteger section;
        
        if ([[results valueForKey:@"feature"] isEqualToString:@"popular"])
        {
            array = self.popularPhotos;
            section = AFViewControllerPopularSection;
        }
        else if ([[results valueForKey:@"feature"] isEqualToString:@"editors"])
        {
            array = self.editorsPhotos;
            section = AFViewControllerEditorsSection;
        }
        else if ([[results valueForKey:@"feature"] isEqualToString:@"upcoming"])
        {
            array = self.upcomingPhotos;
            section = AFViewControllerUpcomingSection;
        }
        else
        {
            NSLog(@"%@", [results valueForKey:@"feature"]);
        }
        
        NSInteger item = 0;
        for (NSDictionary *photo in [results valueForKey:@"photos"])
        {
            [AFImageDownloader imageDownloaderWithURLString:[[[photo valueForKey:@"images"] lastObject] valueForKey:@"url"] autoStart:YES completion:^(UIImage *decompressedImage) {
                
                [array addObject:decompressedImage];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:item inSection:section]]];
            }];
            
            item++;
        }
    };
    
    [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:20 completion:block];
    [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeatureEditors resultsPerPage:20 completion:block];
    [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeatureUpcoming resultsPerPage:20 completion:block];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(void)goBack
{
    if (self.collectionView.collectionViewLayout == self.coverFlowLayout)
    {
        [self.flowLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
    }
    else if (self.collectionView.collectionViewLayout == self.flowLayout)
    {
        [self.stackLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.stackLayout animated:YES];
        
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    }
}

#pragma mark - UICollectionView Delegate & DataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return AFViewControllerNumberSections;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *array;
    
    switch (indexPath.section) {
        case AFViewControllerPopularSection:
            array = self.popularPhotos;
            break;
        case AFViewControllerEditorsSection:
            array = self.editorsPhotos;
            break;
        case AFViewControllerUpcomingSection:
            array = self.upcomingPhotos;
            break;
    }
    
    if (indexPath.row < array.count)
    {
        [cell setImage:array[indexPath.item]];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView.collectionViewLayout == self.stackLayout)
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        
        [self.flowLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.flowLayout animated:YES];
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)] animated:YES];
    }
    else if (self.collectionView.collectionViewLayout == self.flowLayout)
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        
        [self.coverFlowLayout invalidateLayout];
        [self.collectionView setCollectionViewLayout:self.coverFlowLayout animated:YES];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically | UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else
    {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case AFViewControllerPopularSection:
            [headerView setText:@"Popular"];
            break;
        case AFViewControllerEditorsSection:
            [headerView setText:@"Editors' Choice"];
            break;
        case AFViewControllerUpcomingSection:
            [headerView setText:@"Upcoming"];
            break;
    }
    
    return headerView;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionViewLayout == self.coverFlowLayout)
    {
        CGFloat margin = 0.0f;
        
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            margin = 130.0f;
        }
        else
        {
            margin = 280.0f;
        }
        
        UIEdgeInsets insets = UIEdgeInsetsZero;
        
        if (section == 0)
        {
            insets.left = margin;
        }
        else if (section == [collectionView numberOfSections] - 1)
        {
            insets.right = margin;
        }
        
        return insets;
    }
    else if (collectionViewLayout == self.flowLayout)
    {
        return self.flowLayout.sectionInset;
    }
    else
    {
        // Should never happen.
        return UIEdgeInsetsZero;
    }
}

@end
