//
//  MJTableViewSection.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MJTableViewCell : NSObject
@property (nonatomic, readonly, copy) NSString *imageName;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, strong) NSDate *date;
@property (nonatomic, readonly, strong) NSNumber *tag;
@end

@interface MJTableViewSection : NSObject
@property (nonatomic, readonly, copy) NSString *headerTitle;
@property (nonatomic, readonly, copy) NSString *footerTitle;
@property (nonatomic, readonly, strong) NSArray<MJTableViewCell *> *cells;
@end

NS_ASSUME_NONNULL_END
