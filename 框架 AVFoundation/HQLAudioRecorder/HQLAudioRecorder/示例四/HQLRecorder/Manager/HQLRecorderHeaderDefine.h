//
//  HQLRecorderHeaderDefine.h
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//
//  MARK: 参考 <https://github.com/SpringAndSummer/MOKORecorder>

#ifndef HQLRecorderHeaderDefine_h
#define HQLRecorderHeaderDefine_h

/// 录音状态
typedef NS_ENUM(NSUInteger, HQLRecordState) {
    HQLRecordStateNormal,           //初始状态
    HQLRecordStateRecording,        //正在录音
    HQLRecordStateReleaseToCancel,  //上滑取消（也在录音状态，UI显示有区别）
    HQLRecordStateRecordCounting,   //最后10s倒计时（也在录音状态，UI显示有区别）
    HQLRecordStateRecordTooShort,   //录音时间太短（录音结束了）
};

#endif /* HQLRecorderHeaderDefine_h */
