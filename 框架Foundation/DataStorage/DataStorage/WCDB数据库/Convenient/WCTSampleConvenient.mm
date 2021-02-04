//
//  WCTSampleConvenient.m
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/18.
//

#import "WCTSampleConvenient.h"
#import "WCTSampleConvenient+WCTTableCoding.h"
#import <WCDB/WCDB.h>

@implementation WCTSampleConvenient

WCDB_IMPLEMENTATION(WCTSampleConvenient)

WCDB_SYNTHESIZE(WCTSampleConvenient, intValue)
WCDB_SYNTHESIZE(WCTSampleConvenient, stringValue)

WCDB_PRIMARY_AUTO_INCREMENT(WCTSampleConvenient, intValue)

@end
