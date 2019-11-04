//
//  ScaryBugs+CoreDataProperties.h
//  
//
//  Created by Qilin Hu on 2018/1/3.
//
//

#import "ScaryBugs+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ScaryBugs (CoreDataProperties)

+ (NSFetchRequest<ScaryBugs *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) float rating;

@end

NS_ASSUME_NONNULL_END
