//
//  AFViewController.m
//  Performance Problems Example II
//
//  Created by Ash Furrow on 2012-12-27.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"

//View
#import "AFCollectionViewCell.h"

//Model
#import "AFModel.h"

@interface AFViewController (Private)

-(void)setupModel; //Called once; not important to example.

@end

@implementation AFViewController
{
    UICollectionView *commentCollectionView;
    UICollectionViewFlowLayout *commentFlowLayout;
    
    NSArray *comments;
}

static NSString *CellIdentifier = @"CellIdentifier";

-(void)loadView
{
    //Create our view
    self.view = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Set up our model
    [self setupModel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create a basic two-column flow layout (more columns in landscape)
    commentFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    commentFlowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    commentFlowLayout.minimumInteritemSpacing = 10.0f;
    commentFlowLayout.minimumLineSpacing = 10.0f;
    commentFlowLayout.itemSize = CGSizeMake(145, 100);
    
    //Create a new collection view with our flow layout and set ourself as delegate and data source
    commentCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:commentFlowLayout];
    commentCollectionView.dataSource = self;
    commentCollectionView.delegate = self;
    
    //Register our nub so we can use our custom subclass cell
    [commentCollectionView registerNib:[UINib nibWithNibName:@"AFCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    
    //Set up the collection view geometry to cover the whole screen in any orientation and other view properties
    commentCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    commentCollectionView.opaque = NO;
    commentCollectionView.backgroundColor = [UIColor clearColor];
    
    //Create a background view
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat.jpg"]];
    imageView.frame = self.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeCenter;
    
    //Finally, assemble our view complete hierarchy
    [self.view addSubview:imageView];
    [self.view addSubview:commentCollectionView];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [comments count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell withModel:comments[indexPath.row]];
    
    return cell;
}

#pragma mark - Private Custom Methods

-(void)configureCell:(AFCollectionViewCell *)cell withModel:(AFModel *)model
{
    cell.backgroundColorView.backgroundColor = [model.color colorWithAlphaComponent:0.6f];
    cell.label.text = model.comment;
}

@end









@implementation AFViewController (Private)

-(void)setupModel
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    const NSInteger kNumComments = 60;
    
    for (NSInteger i = 0; i < kNumComments; i++)
    {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        
        UIColor *color = [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f];
        
        switch (arc4random() % 6) {
            case 0:
                [mutableArray addObject:[AFModel modelWithComment:@"OMG! Awesome!" color:color]];
                break;
            case 1:
                [mutableArray addObject:[AFModel modelWithComment:@"Amazing! Nice cat!" color:color]];
                break;
            case 2:
                [mutableArray addObject:[AFModel modelWithComment:@"😺" color:color]];
                break;
            case 3:
                [mutableArray addObject:[AFModel modelWithComment:@"Meow!" color:color]];
                break;
            case 4:
                [mutableArray addObject:[AFModel modelWithComment:@"He looks so crazy!" color:color]];
                break;
            case 5:
                [mutableArray addObject:[AFModel modelWithComment:@"Sweet!" color:color]];
                break;
            default:
                break;
        }
    }
    
    comments = [NSArray arrayWithArray:mutableArray];
}

@end
