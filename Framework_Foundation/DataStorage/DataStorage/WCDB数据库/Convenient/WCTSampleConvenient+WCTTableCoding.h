//
//  WCTSampleConvenient+WCTTableCoding.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/18.
//

#import "WCTSampleConvenient.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTSampleConvenient (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(intValue)
WCDB_PROPERTY(stringValue)

@end

NS_ASSUME_NONNULL_END
