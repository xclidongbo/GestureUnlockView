//
//  GestureUnlockView.h
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUManager.h"

// 只返回每次调用的数据
@interface GestureUnlockView : UIView

//- (void)gestureUnlockViewRecognizerStateEnded:(void(^)(GestureUnlockView * sender, NSString * gesturePwd))endBlock;



- (void)normalState;
- (void)errorState;


@end
