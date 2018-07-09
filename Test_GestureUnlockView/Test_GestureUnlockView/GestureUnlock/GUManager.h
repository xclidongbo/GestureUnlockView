//
//  GUManager.h
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GUStyles.h"

//定义枚举, 包括 创建, 修改, 校验 场景
typedef NS_ENUM(NSInteger, GestureUnlockViewState) {
    GestureUnlockViewStateCreate,
    GestureUnlockViewStateModify,
    GestureUnlockViewStateVerify,
};


typedef NS_ENUM(NSInteger, GestureUnlockResult) {
    GestureUnlockResultCreateFirstSuccess,//首次创建
    GestureUnlockResultCreateFinalSuccess,//最终创建
    GestureUnlockResultCreateFailure,     //创建失败
    GestureUnlockResultCreateErrorCheckout,     //创建pwd校验失败
    
    GestureUnlockResultVerifySuccess,     //修改成功
    GestureUnlockResultVerifyFailure,     //修改失败
};



// 状态存取. 各种场景返回的数据
@class GestureUnlockView;
@interface GUManager : NSObject


// 用来清空标记
+ (void)setTempString:(NSString *)tempString;
+ (void)setCreateForModify:(BOOL)createForModify;


+ (void)gestureUnlockEnd:(GestureUnlockView *)sender gesturePwd:(NSString *)gesturePwd;
/**
 存储的手势密码
 */
+ (NSString *)gesturePwd;


#pragma mark - 以下外部使用

+ (void)setSharedStyle:(GUStyles *)sharedStyle;
+ (GUStyles *)sharedStyle;

+ (void)gestureUnlockEndWithState:(GestureUnlockViewState)state complete:(void(^)(GestureUnlockView * sender, NSString * gesturePwd, GestureUnlockResult result))complete;

+ (void)resetState;

//是否已经创建(设置)手势密码
+ (BOOL)isCreateGesturePwd;

//是否显示手势轨迹
+ (void)setGestureTrackStatus:(BOOL)gestureTrack;
+ (BOOL)showGestureTrack;




@end
