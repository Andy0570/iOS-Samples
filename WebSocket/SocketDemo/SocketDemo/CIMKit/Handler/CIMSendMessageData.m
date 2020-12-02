//
//  CIMSendMessage.m
//  CIMKit
//
//  Created by mason on 2020/11/13.
//

#import "CIMSendMessageData.h"
#import "CIMHeader.h"
#import "SentBody.pbobjc.h"
#import <UIKit/UIDevice.h>
#import <JKCategories/UIDevice+JKHardware.h>

@implementation CIMSendMessageData


/// 心跳包数据
+(NSData *)initHeartbeatData{
    NSData * model = [@"CR" convertBytesStringToData];
    NSInteger lenght = model.length;
    Byte type = 0;
    Byte head[3] ;
    head[0] = type;
    head[1] = lenght & 0xff;
    head[2] = (lenght >> 8) & 0xff;
    NSMutableData * sendData = [[NSMutableData alloc] initWithBytes:head length:3];
    [sendData appendData:model];
    
    return sendData;
}


/// 绑定用户数据
/// @param userId userId description
+(NSData *)initBindUserData:(NSString *)userId{
    SentBodyModel * body = [SentBodyModel new];
    body.key = @"client_bind";
    body.timestamp = (int64_t)[NSDate timeIntervalSinceReferenceDate] *1000;
    body.data_p[@"account"] = userId;
    body.data_p[@"deviceId"] = [[self class] deviceId];
    body.data_p[@"channel"] = @"ios";
    NSData *modeData = body.data;
    NSInteger lenght = modeData.length;
    Byte type = 3;
    Byte head[3] ;
    head[0] = type;
    head[1] = lenght & 0xff;
    head[2] = (lenght >> 8) & 0xff;
    NSMutableData * sendData = [[NSMutableData alloc] initWithBytes:head length:3];
    [sendData appendData:modeData];
    return sendData;

}

+(NSData *)initMessageData:(NSString *)userId{
    SentBodyModel * body = [SentBodyModel new];
    body.key = @"client_bind";
    body.timestamp = (int64_t)[NSDate timeIntervalSinceReferenceDate] *1000;
    body.data_p[@"account"] = userId;
    body.data_p[@"deviceId"] = [[self class] deviceId];
    body.data_p[@"channel"] = @"ios";
    
    body.data_p[@"device_model"] = UIDevice.jk_platformString; // 机型名称
    body.data_p[@"os_version"] = UIDevice.jk_systemVersion; // 系统版本号
    // 获取当前 APP 版本号，发布版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    body.data_p[@"app_version"] = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSData *modeData = body.data;
    NSInteger lenght = modeData.length;
    Byte type = 3;
    Byte head[3] ;
    head[0] = type;
    head[1] = lenght & 0xff;
    head[2] = (lenght >> 8) & 0xff;
    NSMutableData * sendData = [[NSMutableData alloc] initWithBytes:head length:3];
    [sendData appendData:modeData];
    return sendData;

}


+(NSString *)deviceId{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}



@end
