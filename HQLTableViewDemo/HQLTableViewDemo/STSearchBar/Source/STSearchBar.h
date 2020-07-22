//
//  STSearchBar.h
//  STSearchBar
//
//  Created by 沈兆良 on 16/8/17.
//  Copyright © 2016年 沈兆良. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class STSearchBar;
@protocol STSearchBarDelegate <UIBarPositioningDelegate>

@optional
-(BOOL)searchBarShouldBeginEditing:(STSearchBar *)searchBar;                      // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(STSearchBar *)searchBar;                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(STSearchBar *)searchBar;                        // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(STSearchBar *)searchBar;                       // called when text ends editing
- (void)searchBar:(STSearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
- (BOOL)searchBar:(STSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; // called before text changes

- (void)searchBarSearchButtonClicked:(STSearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(STSearchBar *)searchBar;                     // called when cancel button pressed
// called when cancel button pressed
@end

@interface STSearchBar : UIView<UITextInputTraits>

@property(nullable,nonatomic,weak) id<STSearchBarDelegate> delegate; // default is nil. weak reference
@property(nullable,nonatomic,copy) NSString  *text;                  // current/starting search text
@property(nullable,nonatomic,copy) NSString  *placeholder;           // default is nil. string is drawn 70% gray
@property(nonatomic) BOOL  showsCancelButton;                        // default is yes
@property(nullable,nonatomic,strong) UIColor *textColor;             // default is nil. use opaque black
@property(nullable,nonatomic,strong) UIFont  *font;                  // default is nil. use system font 12 pt
@property(nullable,nonatomic,strong) UIColor *placeholderColor;      // default is drawn 70% gray

/* Allow placement of an input accessory view to the keyboard for the search bar
 */
@property (nullable,nonatomic,readwrite,strong) UIView *inputAccessoryView;

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

@end

NS_ASSUME_NONNULL_END
