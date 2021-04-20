//
//  RecipeDetailViewController.m
//  RecipeBook
//
//  Created by Qilin Hu on 2021/3/30.
//

#import "RecipeDetailViewController.h"

@interface RecipeDetailViewController ()

@end

@implementation RecipeDetailViewController

@synthesize recipeLabel;
@synthesize recipeName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    recipeLabel.text = recipeName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
