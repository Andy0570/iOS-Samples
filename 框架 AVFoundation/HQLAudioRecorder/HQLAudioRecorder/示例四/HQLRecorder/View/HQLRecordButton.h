//
//  HQLRecordButton.h
//  IMKit
//
//  Created by Qilin Hu on 2021/2/22.
//

#import <UIKit/UIKit.h>
@class HQLRecordButton;

NS_ASSUME_NONNULL_BEGIN

typedef void(^HQLRecordButtonTouchAction)(HQLRecordButton *recordButton);

/// 语音输入按钮：按住说话，松开结束
@interface HQLRecordButton : UIButton

@property (nonatomic, copy) HQLRecordButtonTouchAction touchDownAction;
@property (nonatomic, copy) HQLRecordButtonTouchAction touchUpOutsideAction;
@property (nonatomic, copy) HQLRecordButtonTouchAction touchUpInsideAction;
@property (nonatomic, copy) HQLRecordButtonTouchAction touchDragEnterAction;
@property (nonatomic, copy) HQLRecordButtonTouchAction touchDragInsideAction;
@property (nonatomic, copy) HQLRecordButtonTouchAction touchDragOutsideAction;
@property (nonatomic, copy) HQLRecordButtonTouchAction touchDragExitAction;

- (void)setButtonStateWithRecording;
- (void)setButtonStateWithNormal;

@end

NS_ASSUME_NONNULL_END
