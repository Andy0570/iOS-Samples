//
//  AFViewController.m
//  Chapter 2 Project 6
//
//  Created by Ash Furrow on 2012-12-17.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFViewController.h"

#import "AFCollectionViewCell.h"

static NSString *CellIdentifier = @"Cell Identifier";

@implementation AFViewController
{
    //models
    NSArray *imageArray;
    NSArray *colorArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set up our models
    NSMutableArray *mutableImageArray = [NSMutableArray arrayWithCapacity:12];
    for (NSInteger i = 0; i < 12; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        [mutableImageArray addObject:[UIImage imageNamed:imageName]];
    }
    imageArray = [NSArray arrayWithArray:mutableImageArray];
    
    NSMutableArray *mutableColorArray = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 10; i++)
    {
        CGFloat redValue = (arc4random() % 255) / 255.0f;
        CGFloat blueValue = (arc4random() % 255) / 255.0f;
        CGFloat greenValue = (arc4random() % 255) / 255.0f;
        
        [mutableColorArray addObject:[UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1.0f]];
    }
    colorArray = [NSArray arrayWithArray:mutableColorArray];
    
    //configure our collection view
    self.collectionView.allowsMultipleSelection = YES;
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return colorArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewCell *cell = (AFCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.image = imageArray[indexPath.item];
    cell.backgroundColor = colorArray[indexPath.section];
    
    return cell;
}


@end
