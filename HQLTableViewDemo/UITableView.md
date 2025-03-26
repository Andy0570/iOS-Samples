# UITableView 概述

[TOC]

## 1.基本介绍


### 层次结构


​    
## 2.UITableViewDataSource



### UITableView.h

```objective-c
//
//  UITableView.h
//  UIKit
//
//  Copyright (c) 2005-2016 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIScrollView.h>
#import <UIKit/UISwipeGestureRecognizer.h>
#import <UIKit/UITableViewCell.h>
#import <UIKit/UIKitDefines.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, UITableViewStyle) {
    UITableViewStylePlain,          // 正常列表，每一行之间有分割线
    UITableViewStyleGrouped         // 分组列表
};

typedef NS_ENUM(NSInteger, UITableViewScrollPosition) {
    UITableViewScrollPositionNone,
    UITableViewScrollPositionTop,    
    UITableViewScrollPositionMiddle,   
    UITableViewScrollPositionBottom
};                // scroll so row of interest is completely visible at top/center/bottom of view

typedef NS_ENUM(NSInteger, UITableViewRowAnimation) {
    UITableViewRowAnimationFade,
    UITableViewRowAnimationRight,           // slide in from right (or out to right)
    UITableViewRowAnimationLeft,
    UITableViewRowAnimationTop,
    UITableViewRowAnimationBottom,
    UITableViewRowAnimationNone,            // available in iOS 3.0
    UITableViewRowAnimationMiddle,          // available in iOS 3.2.  attempts to keep cell centered in the space it will/did occupy
    UITableViewRowAnimationAutomatic = 100  // available in iOS 5.0.  chooses an appropriate animation style for you
};

// Including this constant string in the array of strings returned by sectionIndexTitlesForTableView: will cause a magnifying glass icon to be displayed at that location in the index.
// This should generally only be used as the first title in the index.
UIKIT_EXTERN NSString *const UITableViewIndexSearch NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED;

// Returning this value from tableView:heightForHeaderInSection: or tableView:heightForFooterInSection: results in a height that fits the value returned from
// tableView:titleForHeaderInSection: or tableView:titleForFooterInSection: if the title is not nil.
UIKIT_EXTERN const CGFloat UITableViewAutomaticDimension NS_AVAILABLE_IOS(5_0);

@class UITableView;
@class UINib;
@protocol UITableViewDataSource;
@protocol UITableViewDataSourcePrefetching;
@class UILongPressGestureRecognizer;
@class UITableViewHeaderFooterView;
@class UIRefreshControl;
@class UIVisualEffect;

typedef NS_ENUM(NSInteger, UITableViewRowActionStyle) {
    UITableViewRowActionStyleDefault = 0,
    UITableViewRowActionStyleDestructive = UITableViewRowActionStyleDefault,
    UITableViewRowActionStyleNormal
} NS_ENUM_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED;

NS_CLASS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED @interface UITableViewRowAction : NSObject <NSCopying>

+ (instancetype)rowActionWithStyle:(UITableViewRowActionStyle)style title:(nullable NSString *)title handler:(void (^)(UITableViewRowAction *action, NSIndexPath *indexPath))handler;

@property (nonatomic, readonly) UITableViewRowActionStyle style;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) UIColor *backgroundColor; // default background color is dependent on style
@property (nonatomic, copy, nullable) UIVisualEffect* backgroundEffect;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface UITableViewFocusUpdateContext : UIFocusUpdateContext

@property (nonatomic, strong, readonly, nullable) NSIndexPath *previouslyFocusedIndexPath;
@property (nonatomic, strong, readonly, nullable) NSIndexPath *nextFocusedIndexPath;

@end

//_______________________________________________________________________________________________________________
// this represents the display and behaviour of the cells.
// 处理每列的行为和显示。

@protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>

@optional

// 定制显示

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

// 支持可变高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

// 使用 estimatedHeight 方法来快速计算高度估计值，这将加快列表加载的时间。
// 如果这些方法被实现了，那么上述 -tableView：heightForXXX 调用将被延迟，直到视图准备好显示，因此那里可以放置更复杂的逻辑。
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0);
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0);

// 列表每段的段头和段尾信息。 如果你不仅仅是显示标题信息，那么这两种方法应该都实现。

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. 将被调整为默认或指定的标题高度
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height

// 指示器

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath NS_DEPRECATED_IOS(2_0, 3_0) __TVOS_PROHIBITED;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

// 段

// 当用户按下列表某一行的时候 -tableView:shouldHighlightRowAtIndexPath: 将会被调用. 
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0);

// 在用户更改选择某一行之前调用。 返回一个新的indexPath或nil来更改段落。
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
// 在用户更改选择某一行之后调用。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
// 用户取消选择某一行之后调用
// 触发的逻辑是：用户选择了第一行，触发 didSelectRowAtIndexPath：方法，再选择第二行，先触发 didDeselectRowAtIndexPath：方法，再触发 didSelectRowAtIndexPath：方法。
// 如果用户重复选择第一行，只会触发 didSelectRowAtIndexPath：方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);

// 编辑

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED;
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED; // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath __TVOS_PROHIBITED;
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath __TVOS_PROHIBITED;

// 移动/重新排序

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;               

// 缩进

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath; // return 'depth' of row for hierarchies

// 复制/粘贴.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0);
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0);
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0);

// Focus

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);
- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0);
- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0);
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView NS_AVAILABLE_IOS(9_0);

@end

UIKIT_EXTERN NSNotificationName const UITableViewSelectionDidChangeNotification;


//_______________________________________________________________________________________________________________

NS_CLASS_AVAILABLE_IOS(2_0) @interface UITableView : UIScrollView <NSCoding>

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER; // must specify style at creation. -initWithFrame: calls this with UITableViewStylePlain
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) UITableViewStyle style;
@property (nonatomic, weak, nullable) id <UITableViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <UITableViewDelegate> delegate;
@property (nonatomic, weak) id<UITableViewDataSourcePrefetching> prefetchDataSource NS_AVAILABLE_IOS(10_0);
@property (nonatomic) CGFloat rowHeight;             // will return the default value if unset
@property (nonatomic) CGFloat sectionHeaderHeight;   // will return the default value if unset
@property (nonatomic) CGFloat sectionFooterHeight;   // will return the default value if unset
@property (nonatomic) CGFloat estimatedRowHeight NS_AVAILABLE_IOS(7_0); // default is 0, which means there is no estimate
@property (nonatomic) CGFloat estimatedSectionHeaderHeight NS_AVAILABLE_IOS(7_0); // default is 0, which means there is no estimate
@property (nonatomic) CGFloat estimatedSectionFooterHeight NS_AVAILABLE_IOS(7_0); // default is 0, which means there is no estimate
@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR; // allows customization of the frame of cell separators

@property (nonatomic, strong, nullable) UIView *backgroundView NS_AVAILABLE_IOS(3_2); // the background view will be automatically resized to track the size of the table view.  this will be placed as a subview of the table view behind all cells and headers/footers.  default may be non-nil for some devices.

// Data

- (void)reloadData; // reloads everything from scratch. redisplays visible rows. because we only keep info about visible rows, this is cheap. will adjust offset if table shrinks
- (void)reloadSectionIndexTitles NS_AVAILABLE_IOS(3_0);   // reloads the index bar.

// Info

@property (nonatomic, readonly) NSInteger numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (CGRect)rectForSection:(NSInteger)section;                                    // includes header, footer and all rows
- (CGRect)rectForHeaderInSection:(NSInteger)section;
- (CGRect)rectForFooterInSection:(NSInteger)section;
- (CGRect)rectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point;                         // returns nil if point is outside of any row in the table
- (nullable NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;                      // returns nil if cell is not visible
- (nullable NSArray<NSIndexPath *> *)indexPathsForRowsInRect:(CGRect)rect;                              // returns nil if rect not valid

- (nullable __kindof UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;   // returns nil if cell is not visible or index path is out of range
@property (nonatomic, readonly) NSArray<__kindof UITableViewCell *> *visibleCells;
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForVisibleRows;

- (nullable UITableViewHeaderFooterView *)headerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);
- (nullable UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section NS_AVAILABLE_IOS(6_0);

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToNearestSelectedRowAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

// Row insertion/deletion/reloading.

- (void)beginUpdates;   // allow multiple insert/delete of rows and sections to be animated simultaneously. Nestable
- (void)endUpdates;     // only call insert/delete/reload calls or change the editing state inside an update block.  otherwise things like row count, etc. may be invalid.

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection NS_AVAILABLE_IOS(5_0);

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation NS_AVAILABLE_IOS(3_0);
- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath NS_AVAILABLE_IOS(5_0);

// Editing. When set, rows show insert/delete/reorder controls based on data source queries

@property (nonatomic, getter=isEditing) BOOL editing;                             // default is NO. setting is not animated.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

@property (nonatomic) BOOL allowsSelection NS_AVAILABLE_IOS(3_0);  // default is YES. Controls whether rows can be selected when not in editing mode
@property (nonatomic) BOOL allowsSelectionDuringEditing;                                 // default is NO. Controls whether rows can be selected when in editing mode
@property (nonatomic) BOOL allowsMultipleSelection NS_AVAILABLE_IOS(5_0);                // default is NO. Controls whether multiple rows can be selected simultaneously
@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing NS_AVAILABLE_IOS(5_0);   // default is NO. Controls whether multiple rows can be selected simultaneously in editing mode

// Selection

@property (nonatomic, readonly, nullable) NSIndexPath *indexPathForSelectedRow; // returns nil or index path representing section and row of selection.
@property (nonatomic, readonly, nullable) NSArray<NSIndexPath *> *indexPathsForSelectedRows NS_AVAILABLE_IOS(5_0); // returns nil or a set of index paths representing the sections and rows of the selection.

// Selects and deselects rows. These methods will not call the delegate methods (-tableView:willSelectRowAtIndexPath: or tableView:didSelectRowAtIndexPath:), nor will it send out a notification.
- (void)selectRowAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

// Appearance

@property (nonatomic) NSInteger sectionIndexMinimumDisplayRowCount;                                                      // show special section index list on right when row count reaches this value. default is 0
@property (nonatomic, strong, nullable) UIColor *sectionIndexColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;                   // color used for text of the section index
@property (nonatomic, strong, nullable) UIColor *sectionIndexBackgroundColor NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;         // the background color of the section index while not being touched
@property (nonatomic, strong, nullable) UIColor *sectionIndexTrackingBackgroundColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR; // the background color of the section index while it is being touched

@property (nonatomic) UITableViewCellSeparatorStyle separatorStyle __TVOS_PROHIBITED; // default is UITableViewCellSeparatorStyleSingleLine
@property (nonatomic, strong, nullable) UIColor *separatorColor UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED; // default is the standard separator gray
@property (nonatomic, copy, nullable) UIVisualEffect *separatorEffect NS_AVAILABLE_IOS(8_0) UI_APPEARANCE_SELECTOR __TVOS_PROHIBITED; // effect to apply to table separators

@property (nonatomic) BOOL cellLayoutMarginsFollowReadableWidth NS_AVAILABLE_IOS(9_0); // if cell margins are derived from the width of the readableContentGuide.

@property (nonatomic, strong, nullable) UIView *tableHeaderView;                           // accessory view for above row content. default is nil. not to be confused with section header
@property (nonatomic, strong, nullable) UIView *tableFooterView;                           // accessory view below content. default is nil. not to be confused with section footer

- (nullable __kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;  // Used by the delegate to acquire an already allocated cell, in lieu of allocating a new one.
- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0); // newer dequeue method guarantees a cell is returned and resized properly, assuming identifier is registered
- (nullable __kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);  // like dequeueReusableCellWithIdentifier:, but for headers/footers

// Beginning in iOS 6, clients can register a nib or class for each cell.
// If all reuse identifiers are registered, use the newer -dequeueReusableCellWithIdentifier:forIndexPath: to guarantee that a cell instance is returned.
// Instances returned from the new dequeue method will also be properly sized when they are returned.
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(5_0);
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);

- (void)registerNib:(nullable UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (void)registerClass:(nullable Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);

// Focus

@property (nonatomic) BOOL remembersLastFocusedIndexPath NS_AVAILABLE_IOS(9_0); // defaults to NO. If YES, when focusing on a table view the last focused index path is focused automatically. If the table view has never been focused, then the preferred focused index path is used.

@end

//_______________________________________________________________________________________________________________
// 该协议用于提供数据模型对象。 因此，它不提供有关外观的信息（包括cell）

@protocol UITableViewDataSource<NSObject>

@required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;                               // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end


// _______________________________________________________________________________________________________________
// this protocol can provide information about cells before they are displayed on screen.

@protocol UITableViewDataSourcePrefetching <NSObject>

@required

// indexPaths are ordered ascending by geometric distance from the table view
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@optional

// indexPaths that previously were considered as candidates for pre-fetching, but were not actually used; may be a subset of the previous call to -tableView:prefetchRowsAtIndexPaths:
- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

@end


//_______________________________________________________________________________________________________________

// This category provides convenience methods to make it easier to use an NSIndexPath to represent a section and row
@interface NSIndexPath (UITableView)

+ (instancetype)indexPathForRow:(NSInteger)row inSection:(NSInteger)section;

@property (nonatomic, readonly) NSInteger section;
@property (nonatomic, readonly) NSInteger row;

@end

NS_ASSUME_NONNULL_END
```












## 3.UITableViewDelegate







## 4.性能优化

## 重用UITableViewCell
原因：



### 方法一：

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 设置重用标识符
	static NSString *CellReuseIdentifier = @"UITableViewCellStyleDefault";
    
    // 根据重用标识符找到可重用的 cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    
    // 如果没有可重用的 cell，则手动创建	
    if (!cell) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellReuseIdentifier];
      }
  
    // 渲染数据...
    return cell;
}
```

* 可以在 `initWithStyle: reuseIdentifier:` 方法中设置你需要使用到的 **UITableViewCell** 的四种样式之一。且不必在初始化时向 **tableView** 注册 celI 类型。
* 使用旧式的 `dequeueReuseableCellWithIdentifier:` 方法需要判断返回的 cell 是否为空，并手动创建新的cell 对象。
* ⚠️ 需要注意的是，千万不要将渲染数据的操作放到 `if(!cell){}` 代码块里面，尤其是设置颜色、字体等操作，这样可能会引起显示数据错乱的问题。



### 方法二：

有时系统默认的4种 **TableViewCellStyle** 类型无法满足需求，所以我们需要自定义cell 类型，也就是创建 **UITableViewCell** 子类对象，如果你需要注册重用 **UITableViewCell** 子类对象 ：

* 第一步   

  ```objective-c
  #import "MyTableViewController.h"
  #import "MyTableViewCell.h" // 导入自定义类
  
  // 声明一个静态变量用于重用标识
  static NSString *const CellReuseIdentifier = @"MyTableViewCell";
  
  //...
  
  - (void)viewDidLoad {
      [super viewDidLoad];
  	
      //*********   1.1 你可以注册通过 NIB 方式创建的 cell   ************
  	// 注册重用自定义的 tableViewCell
      // 创建 UINib 对象，该对象代表包含了 MyTableViewCell 的 NIB 文件
    	UINib *nib = [UINib nibWithNibName:NSStringFromClass([MyTableViewCell class])
                                  bundle:[NSBundle mainBundle]];
    	// 通过 UINib 对象注册相应的 Nib 文件
    	[self.tableView registerNib:nib 
           forCellReuseIdentifier:CellReuseIdentifier];
    
      //*********   1.2 也可以注册通过代码方式创建的 cell   ************
      [self.tableView registerClass:[MyTableViewCell class]
             forCellReuseIdentifier:cellReuseIdentifier];
  }
  ```



* 第二步

  ```objective-c
  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  	// 获取 MyTableViewCell 对象，返回的可能是现有的对象，也有可能是新创建的对象
      MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
      
    // 渲染数据...
  	return cell;
  }
  ```

* 将 cell 的创建过程交由系统管理，如果没有可用复用的 cell 时， runtime 将自动使用注册时提供的资源去新建一个cell并返回。因此可省略判断获取的cell是否为空。

* 使用 `dequeueReusableCellWithIdentifier: forIndexPath:` 方法必须提前在初始化时向 **tableView** 注册重用的 cell 类型。

* 获取通过 NIB 方式创建的 cell 时，若无可重用cell，系统将创建新的cell，并调用其中的 `awakeFromNib` 方法，可通过重写这个方法添加更多页面内容。

* ⚠️  使用此方法可能会产生控件重叠问题，**其他设置**中会讲到。



 假如用这种方式创建 **UITableViewCell** 类型：

* 第一步

```objective-c
static NSString * const CellReuseIdentifier = @"UITableViewCellStyleDefault";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册重用 UITableViewCell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
}
```
* 第二步

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    // 设置渲染数据...
	return cell;
}
```

📌如果你要用第二种方法注册重用默认的 **UITableViewCell** 类型也是可以的，但是，用这种方法创建出来的**UITableViewCell** 类型是默认的 **UITableViewCellStyleDefault** 样式的。所以你要是在配置 **cell** 的时候写 ``cell.detailTextLabel.text = @"balabala";`` 是无效的，UI界面上是不会显示这个的。



## 5.UITableViewCell

### UITableViewCellStyle
官方默认的UITableViewCell风格有4种：

1. UITableViewCellStyleDefault
   > 左侧显示textLabel（不显示detailTextLabel），imageView可选（显示在最左边）

   ![UITableViewCellStyleDefault](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/TableView_iPhone/Art/tvcellstyle_default.jpg)


2. UITableViewCellStyleValue1
   > 左侧显示textLabel、右侧显示detailTextLabel（默认灰色），imageView可选（显示在最左边）

   ![UITableViewCellStyleValue1](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/TableView_iPhone/Art/tvcellstyle_value1.jpg)

   


3. UITableViewCellStyleValue2
   > 左侧依次显示textLabel(默认蓝色)和detailTextLabel，imageView可选（显示在最左边）

   ![](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/TableView_iPhone/Art/tvcellstyle_value2.jpg)

4. UITableViewCellStyleSubtitle
   > 左上方显示textLabel，左下方显示detailTextLabel（默认灰色）,imageView可选（显示在最左边） 

   ![UITableViewCellStyleSubtitle](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/TableView_iPhone/Art/tvcellstyle_subtitle.jpg)

## 6.常用操作



## 7.UITableViewController



## 8.UITableView高度自适应实现

### 分4个步骤实现

#### 1️⃣

 **xib** 文件中自定义 `UITableViewCell` 上的控件使用 **Auto Layout**【自上而下】加好约束；

![](https://ww4.sinaimg.cn/large/006tKfTcgy1fdpsuagxr7j30hd04qaap.jpg)



#### 2️⃣

添加一个 `NSMutableDictionary` 属性，用于保存缓存下来的 cell 高度值，这样可以解决点击状态栏不会自动滚动到顶部的问题。

```objective-c
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;
```



#### 3️⃣

实现代理方法：```-(void)tableView: willDisplayCell: forRowAtIndexPath:```

用一个字典做容器，在 cell 将要显示的时候在字典中保存这行 cell 的高度。

```objective-c
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  	
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
  
}
```



#### 4️⃣

实现代理方法：```-(CGFloat)tableView:estimatedHeightForRowAtIndexPath:```

```objective-c
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    // 先去字典查看有没有缓存高度，有就返回，没有就返回一个大概高度
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height) {
        return height.floatValue;
    }else {
        return 100;
    }
  
}
```



### 参考

* [优化UITableViewCell高度计算的那些事 @ForkingDog](http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/)
* [UITableView自动计算cell高度并缓存，再也不用管高度啦](http://www.jianshu.com/p/64f0e1557562)





## 9.MVC模式

​    





## 其它设置
### 初始化默认选中第一行

```objective-c
// 默认选中第一行，并执行点击事件
NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
[self.tableView selectRowAtIndexPath:firstIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

if ([self.tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
    [self.leftTableView.delegate tableView:self.tableView didSelectRowAtIndexPath:firstIndexPath];
}
```



### cell 点按效果

```objective-c
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
```



### 隐藏表尾视图（TableFooterView）空白部分的单元格分隔线

创建一个空的视图赋值给页脚视图：

```objective-c
UIView *view = [[UIView alloc] init];
view.backgroundColor = [UIColor clearColor];
[self.tableView setTableFooterView:view];
```

或者更简单的写法：

```objective-c
self.tableView.tableFooterView = [UIView new];
```



### 自定义辅助视图

![](https://ws4.sinaimg.cn/large/006tNbRwly1fyngm6pkg5j303k03kq2r.jpg)

```objective-c
// 自定义辅助视图
UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more.png"]];
view.contentMode = UIViewContentModeScaleAspectFit;
view.frame = CGRectMake(0, 0, 25, 25);
cell.accessoryView = view;
```



### 设置分割线样式

    // 设置分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;



### 设置分割线向左顶到头

```objective-c
// Setup your cell margins:
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
     // Remove seperator inset
     // 移除分割线边缘插入量
     if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
         [cell setSeparatorInset:UIEdgeInsetsZero];
     }
     // Prevent the cell from inheriting the Table View's margin settings
     // 防止 cell 继承 TableView 的边缘设置
     if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
         [cell setPreservesSuperviewLayoutMargins:NO]; 
      }
     // Explictly set your cell's layout margins 
     // 显示地设置 cell 的边缘布局
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
         [cell setLayoutMargins:UIEdgeInsetsZero]; 
    }
}
```



### 重用 cell 时产生的控件重叠问题

在 **UITableViewCell** 的使用中，使用纯代码方式添加控件，当复用 cell 的时候，可能会出现控件重叠现象。我们可能需要先对cell中添加的控件进行清空，cell的复用不变，只是在新的cell加载前，都会对上一个cell的`contentView` 中的控件进行清空，示例代码如下：

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{  
    static NSString * CellReuseIdentifier = @"MyTableViewCell";  
    MyTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];  
    
    // TODD:解决cell复用导致的控件重叠问题  
    for (UIView *subview in [cell.contentView subviews]) {  
        [subview removeFromSuperview];  
    }
    // 渲染数据
    cell.data = (MyModel *)_dataSourceArray[indexPath.row];
    return cell;
}
```

> 📌
>
> 上面的方法是网上流行的做法。
>
> 分析控件重叠的原因：可能是在渲染数据时才去 `contentView` 中添加子控件。这样一来，获取到的重用 cell 已经有子控件了，渲染数据时又添加了一遍子控件，因此控件重叠了。
>
> 解决的方法：在获取到可重用 cell 之后，渲染数据之前，将 `contentView` 中的子控件使用 `for in` 循环遍历移除子控件。从深度优化的角度来看，子控件被重复地循环删除-循环添加，势必会产生性能问题。
>
> 建议的方法：将添加 **View** 本身和向 **View** 中设置 **Model** 数据分离开来，初始化 cell 时就 `addSubView:` 并做好自动布局，渲染数据时只是修改数据、颜色和字体。这样可以避免子控件被重复地循环删除-添加。

示例代码：

```objective-c
//
//  MyTableViewCell.m
//  

#import "MyTableViewCell.h"
#import "Model.h"
#import <SDWebImage/UIImageView+WebCache.h>

const CGFloat MyTableViewCellHeight = 90;

@interface MyTableViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation MyTableViewCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, MyTableViewCellHeight);
        // 1.初始化时添加子视图
        [self addSubview];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setData:(Model *)data {
    _data = data;
    // 2.设置模型时再渲染数据
    [self render];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = FONT(17);
    }
    return _nameLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = FONT(15);
    }
    return _typeLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = FONT(15);
        _dateLabel.textColor = HexColor(@"#888888");
    }
    return _dateLabel;
}

#pragma mark - Private

- (void)addSubview {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.dateLabel];
        
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.contentView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(15);
        make.left.equalTo(self.imageView.mas_right).with.offset(15);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(6);
        make.bottom.equalTo(self.nameLabel.mas_bottom);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(6);
        make.left.equalTo(self.imageView.mas_right).with.offset(15);
    }];
}

- (void)render {
    if (!self.data) {
        return;
    }
    [self.imageView sd_setImageWithURL:_data.imageURL
                      placeholderImage:[UIImage imageNamed:@"default"]
                             completed:nil];
        
    self.nameLabel.text = _data.name;
    self.dateLabel.text = _data.thisDate;
  
    if (_data.isAvailable) {
        self.typeLabel.text = _data.Type;
        self.typeLabel.textColor = [UIColor whiteColor];
        self.typeLabel.backgroundColor = [UIColor flatLimeColorDark];
    }else {
        self.typeLabel.text = _data.Type;
        self.typeLabel.textColor = HexColor(@"#BBBBBB");
        self.typeLabel.backgroundColor = HexColor(@"DDDDDD");
    }
}

@end
```

> 以上在 View 中设置 Model 可能违反了 MVC 的初衷，你也可以创建一个 **Category** 类单独实现渲染数据的操作。不管怎样，我们起码解决了Cell控件重叠的问题，也避免子控件被重复地循环删除-添加的操作。



### 设置tableHeaderView

设置 tableHeaderView 可以代码实现，也可以 NIB 实现。

NIB 实现在 [《iOS编程（第四版）》Demo8：Homeowner](http://www.jianshu.com/p/08d097e17a25) 这篇文章中 **第8条 编辑模式** 有提及。



#### 遇到的问题：

为 **UITableView** 设置表头视图时，使用XIB方式创建了一个 **UIVIew** 作为 `tableHeaderView`。

表头视图的高度总是不对：

参考了两种解决方法：

* [iOS tableViewHeader AutoLayout 高度错误](http://siegrain.wang/post/ios-tableviewheader-autolayout-gao-du-cuo-wu)
* [iOS: TableView HeaderView + AutoLayout](http://真无聊.com/ios之路/HeaderViewAutoLayout)

解决思路：

```objective-c
// 方案一：使用 frame 属性为表头视图设置固定高度
self.tableHeaderView.frame = CGRectMake(0, 0, self.view.width, 124);
self.tableView.tableHeaderView = self.tableHeaderView;

// 方案二：用 systemLayoutSizeFittingSize 方法计算出高度
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    UIView *headerView = self.tableHeaderView;
    CGFloat height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    self.tableView.tableHeaderView = headerView;
}

// 方案二：类似
- (void)setAndLayoutTableHeaderView:(UIView *)header;{
    self.tableHeaderView = header;
    [header setNeedsLayout];
    [header layoutIfNeeded];
    //刷新布局后进行UILabel的宽度设置。
    [self parseTreeWithViewSubViewArray:header.subviews];
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = header.frame;
    frame.size.height = height;
    header.frame = frame;
    self.tableHeaderView = header;
}
```

> ⚠️ 但是这两种方法并没有解决我的问题，方案二的布局子视图方法在我的项目中根本没有执行😂

自己遇到的问题如下：

* 第一种情况是：表头视图和列表视图错位了：



<img src="http://ww1.sinaimg.cn/large/006tKfTcgy1ffiow3oja9j30ku112ada.jpg" width="375" height="667" alt="表头视图和列表视图错位"/>


* 第二种情况是：表头视图和列表视图的距离拉太开了。

<img src="http://ww1.sinaimg.cn/large/006tKfTcgy1ffioxw6aslj30ku112419.jpg" width="375" height="667" alt="表头视图和列表视图的距离拉太开"/>


最后找到的原因是：

![](http://ww1.sinaimg.cn/large/006tKfTcgy1ffip953kz6j30bh0ft0th.jpg)

对，就是那 **64 点导航栏的高度值** 导致的问题。如果没有设置表头视图的话，确实是应该这样布局的，但是有了表头视图之后，这里的高度就应该设置为 0。

还有就是表头视图一定要做好自上而下的约束：

![](http://ww3.sinaimg.cn/large/006tKfTcgy1ffipd2j2lgj30f606fjsc.jpg)



另外，**Autoresizing** 约束也要去掉：

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fhnuxpn4ocj306n01s3yn.jpg)







### 仿Airbnb的tableView头部视图层叠效果

其他开源框架：[**CSStickyHeaderFlowLayout**](https://github.com/CSStickyHeaderFlowLayout/CSStickyHeaderFlowLayout) ⭐️ 5000+



参考：[仿Airbnb的tableView头部视图层叠效果](https://www.jianshu.com/p/faa6a6044c76)

效果：

![](https://ws1.sinaimg.cn/large/006tKfTcgy1fhvx5c2q0fg30af0ij7wj.gif)



```objective-c
//
//  ViewController.m
//  FoldAnimation
//
//  Created by Chris on 16/7/6.
//  Copyright © 2016年 Chris. All rights reserved.
//

#import "ViewController.h"
#import "HeaderView.h"

// 头部视图高度
const CGFloat headerHeight = 318;
// 层叠的覆盖速率
const CGFloat speed = 0.6; // speed <= 0
static NSString * const cellReusreIdentifier = @"UITableViewCell";

@interface ViewController ()

/** header */
@property(nonatomic, strong) HeaderView *header;
/** headerFrame */
@property(nonatomic, assign) CGRect headerFrame;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HeaderView *header = [HeaderView viewFromXib];
    // 一定要将header插入到tableView的下面,才有层叠覆盖的效果
    // 所以说，这里的 HeaderView 并不是 self.tableView.tableHeaderView
    self.header = header;
    [self.view insertSubview:self.header atIndex:0];
    
    // ⭐️ contentInset：额外的滚动区域
    // 给 tableView 顶部插入额外的滚动区域,用来显示头部视图
    // UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    self.tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);
    
    // ⭐️ contentOffset：初始偏移量
    // 应用启动后,tableView 向上偏移headerHeight高度，以滚动到最顶部,显示额外的头部视图
    // contentOffset 代表内容偏移量，CGPoint 类型
    [self.tableView setContentOffset:CGPointMake(0, -headerHeight)];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:cellReusreIdentifier];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    // 每次布局子控件的时候,都要更新头部视图的frame
    // 仅更新 Y 轴，图片以0.6倍的速度向上滚动
    self.header.frame = self.headerFrame;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusreIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"text";
    return cell;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 由于上面设置了应用额外的滚动区域,所以应用一启动就会来到这个方法
  	// scrollView.contentOffset.y 指的是 UIScrollView 在 Y 方向上的偏移量
    // 初始时，scrollView.contentOffset.y (负值)的值是添加的额外滚动的值 headerHeight,
    // 此时 -headerHeight * speed - headerHeight * (1 - speed) = - headerHeight, 从而一启动的时候, 头部视图是按照我们想要的位置布局的
    // 另外该视图中 frame 的起点(0,0)在 tableView 列表的左上角，而不是窗口的左上角，窗口的左上角坐标是(0,-headerHeight)
    
    // 以后当tableView滚动的时候, 头部视图就以我们滚动时的速度的speed倍向上滚动 , 把这个值保存到self.headerFrame, 在viewWillLayoutSubviews中更新头部视图的frame
    
    CGRect frame = CGRectMake(0, -headerHeight, self.view.frame.size.width, headerHeight);
    // scrollView.contentOffset.y * speed - headerHeight * (1 - speed)
    // 头部视图是以手指滚动时的 speed 倍向上滚动
    // - headerHeight * (1 - speed) 是固定值，只是为了保证初始偏移量高度
    frame.origin.y = scrollView.contentOffset.y * speed - headerHeight * (1 - speed);
    self.headerFrame = frame;
}

@end
```











### 参考文献

- [Apple官方文档:Table View Programming Guide for iOS](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/TableView_iPhone/AboutTableViewsiPhone/AboutTableViewsiPhone.html#//apple_ref/doc/uid/TP40007451)
- [~~iOS学习笔记之UITableView（1）@yetcode~~](http://www.jianshu.com/p/d8957a0ef419)  （不全）
- [iOS开发系列--UITableView全面解析 @KenshinCui ](http://www.cnblogs.com/kenshincui/p/3931948.html)   
  （注，文中的**UISearchDisplayController**已被官方弃用）
- [UITableView详解](http://www.kancloud.cn/digest/ios-1/107418)
- [UITableView的基本使用 @Enrica](http://www.jianshu.com/p/c3906d2c4943)
- [UITableView的知识进阶 @ Enrica](http://www.jianshu.com/p/fcf1ca7e644f)
- [可任意自定义的UITableViewCell](http://www.cnblogs.com/lovecode/archive/2012/01/07/2315630.html)
- [UITableViewCell 高度自适应 @Show_Perry](http://www.jianshu.com/p/99f901762f15)
- [利用长按手势移动 Table View Cells @破船之家](http://beyondvincent.com/2014/03/26/2014-03-26-cookbook-moving-table-view-cells-with-a-long-press-gesture/)
- [UITableView详解 (持续更新)](http://www.devzhang.com/14464613593730.html)





### 相关框架

* [RATreeView](https://github.com/Augustyniak/RATreeView)

