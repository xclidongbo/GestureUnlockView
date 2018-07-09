//
//  GUManager.m
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "GUManager.h"
#import "GUStyles.h"
#import <objc/runtime.h>
#import "GestureUnlockView.h"
//static char kGestureEndKey;
static char kGestureStateKey;
static char kGestureUnlockResultKey;

static NSString * const kGestureUnlockPwd = @"kGestureUnlockPwd";
//static NSString * const kGestureUnlockCreate = @"kGestureUnlockCreate";
static NSString * const kGestureUnlockModify = @"kGestureUnlockModify";
//static NSString * const kGestureUnlockVerify = @"kGestureUnlockVerify";
static NSString * const kGestureTrack = @"kGestureTrack";

@interface GUManager ()
@property (nonatomic, strong)GUStyles * sharedStyle;
@property (nonatomic, assign)GestureUnlockViewState unlockViewState;
//@property (nonatomic, assign, getter=isCreated)BOOL created;    //用来本地存储状态

@property (nonatomic, strong)NSString * gesturePwd;

@property (nonatomic, strong)NSString * tempString;


@property (nonatomic, assign, getter=isModify)BOOL createForModify;

@property (nonatomic, assign, getter=showGestureTrack, setter=setGestureTrackStatus:)BOOL gestureTrack;

@end

@implementation GUManager
@synthesize tempString = _tempString;

static GUManager * shared = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[GUManager alloc] init];
    });
    return shared;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.sharedStyle = [[GUStyles alloc] initWithDefaultStyle];
    }
    return self;
}


+ (void)setSharedStyle:(GUStyles *)sharedStyle {
    [[self sharedManager] setSharedStyle:sharedStyle];
}

+ (GUStyles *)sharedStyle {
    return [[self sharedManager] sharedStyle];
}

#pragma mark -
//- (void)setCreated:(BOOL)created {
//    [[NSUserDefaults standardUserDefaults] setBool:created forKey:kGestureUnlockCreate];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (BOOL)isCreated {
//    return [[NSUserDefaults standardUserDefaults] boolForKey:kGestureUnlockCreate];
//}




+ (void)setGesturePwd:(NSString *)gesturePwd {
    return [[self sharedManager] setGesturePwd:gesturePwd];
}

+ (NSString *)gesturePwd {
    return [[self sharedManager] gesturePwd];
}


- (void)setGesturePwd:(NSString *)gesturePwd {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:gesturePwd forKey:kGestureUnlockPwd];
    [userDefault synchronize];
}

- (NSString *)gesturePwd {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kGestureUnlockPwd];
}


+ (void)setTempString:(NSString *)tempString {
    [[self sharedManager] setTempString:tempString];
}



+ (NSString *)tempString {
    return [[self sharedManager] tempString];
}

- (void)setTempString:(NSString *)tempString {
    _tempString = tempString;
}
- (NSString *)tempString {
    return _tempString;
}



+ (BOOL)checkoutPwd:(NSString *)pwd {
    return pwd.length>3?YES:NO;
}


+ (BOOL)isCreateForModify {
    return [[self sharedManager] isCreateForModify];
}
+ (void)setCreateForModify:(BOOL)createForModify {
    [[self sharedManager] setCreateForModify:createForModify];
}


- (BOOL)isCreateForModify {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kGestureUnlockModify];
}
- (void)setCreateForModify:(BOOL)createForModify {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:createForModify forKey:kGestureUnlockModify];
    [userDefault synchronize];
}

+ (BOOL)isCreateGesturePwd {
    return [[self sharedManager] gesturePwd].length>0?YES:NO;
}

+ (void)setGestureTrackStatus:(BOOL)gestureTrack {
    [[self sharedManager] setGestureTrackStatus:gestureTrack];
}

+ (BOOL)showGestureTrack {
    return [[self sharedManager] showGestureTrack];
}
- (void)setGestureTrackStatus:(BOOL)gestureTrack {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:gestureTrack forKey:kGestureTrack];
    [userDefault synchronize];
}
- (BOOL)showGestureTrack {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kGestureTrack];
}


#pragma mark -

+ (void)gestureUnlockEnd:(GestureUnlockView *)sender gesturePwd:(NSString *)gesturePwd {
    
    NSNumber * stateNum = objc_getAssociatedObject(self, &kGestureStateKey);
    NSInteger state = [stateNum integerValue];
    switch (state) {
        case GestureUnlockViewStateCreate:
            //创建
            [self createWithView:sender gesturePwd:gesturePwd];
            break;
        case GestureUnlockViewStateModify:
            //修改
            [self modifyWithView:sender gesturePwd:gesturePwd];
            break;
        case GestureUnlockViewStateVerify:
            //验证
            [self verifyWithView:sender gesturePwd:gesturePwd];
            break;
        default:
            break;
    }
    
}

+ (void)gestureUnlockEndWithState:(GestureUnlockViewState)state complete:(void(^)(GestureUnlockView * sender, NSString * gesturePwd, GestureUnlockResult result))complete {
    //根据需要判断的状态,来写逻辑
    //对比状态下, 需要更改 验证错误后的逻辑.
    
//    objc_setAssociatedObject(self, &kGestureEndKey, endBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    NSNumber * number = [NSNumber numberWithInteger:state];
    objc_setAssociatedObject(self, &kGestureStateKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kGestureUnlockResultKey, complete, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}
+ (void)createWithView:(GestureUnlockView *)sender gesturePwd:(NSString *)gesturePwd  {
    //第一次的结果给一个全局temp.
        //第二次如果和当前的temp相等,就存储当前temp到本地.
            //如果不相等就提示错误, 重新输入.``
                //错误超出次数,就提示错误.
    void(^complete)(GestureUnlockView * sender, NSString * gesturePwd, GestureUnlockResult result) = objc_getAssociatedObject(self, &kGestureUnlockResultKey);
    
    if ([self tempString].length == 0) {
        if (![self checkoutPwd:gesturePwd]) {
            if (complete)complete(sender, gesturePwd, GestureUnlockResultCreateErrorCheckout);
            [sender errorState];
            return;
        };
        [self setTempString:gesturePwd];
        //设置成功的回调.
        NSLog(@"第一次成功,请再次设置");
        if (complete)complete(sender, gesturePwd, GestureUnlockResultCreateFirstSuccess);
    } else {
        if ([[self tempString] isEqualToString:gesturePwd]){
            NSLog(@"第二次创建成功, 缓存");
            if (complete)complete(sender, gesturePwd, GestureUnlockResultCreateFinalSuccess);
            [self setGesturePwd:gesturePwd];
            //清除标记
            [self setCreateForModify:NO];
            [self setTempString:nil];//清除比对的temp数据
        }else{
            NSLog(@"失败,请重试");
            if (complete)complete(sender, gesturePwd, GestureUnlockResultCreateFailure);
            [sender errorState];
            return;
        }
    }
    [sender normalState];
    
//    if (endBlock) endBlock(sender, gesturePwd);
    
    NSLog(@"创建");
}

+ (void)modifyWithView:(GestureUnlockView *)sender gesturePwd:(NSString *)gesturePwd {
    void(^complete)(GestureUnlockView * sender, NSString * gesturePwd, GestureUnlockResult result) = objc_getAssociatedObject(self, &kGestureUnlockResultKey);
    //验证手势密码是否正确. 如果 错误 就提示
        //如果正确 缓存本地,通过验证.
    //根据通过验证的状态, 进入重新创建 手势密码 流程. 创建完毕 清除缓存的状态.
    
    if ([self isCreateForModify] == NO) {
        //校验
        if ([[self gesturePwd] isEqualToString:gesturePwd]) {
            if (complete) complete(sender, gesturePwd, GestureUnlockResultVerifySuccess);
            [sender normalState];
            [self setCreateForModify:YES];
        } else {
            NSLog(@"校验错误");
            if (complete) complete(sender, gesturePwd, GestureUnlockResultVerifyFailure);
            [sender errorState];
        }
        
    } else {
        [self createWithView:sender gesturePwd:gesturePwd];
//        if ([self tempString].length == 0) {
//            if (![self checkoutPwd:gesturePwd]) {
//                if (complete)complete(sender, gesturePwd, GestureUnlockResultCreateErrorCheckout);
//                [sender errorState];
//                return;
//            };
//            [self setTempString:gesturePwd];
//            //设置成功的回调.
//            if (complete) complete(sender, gesturePwd, GestureUnlockResultCreateFirstSuccess);
//            NSLog(@"第一次成功,请再次设置");
//        } else {
//            if ([[self tempString] isEqualToString:gesturePwd]){
//                NSLog(@"第二次创建成功, 缓存");
//                if (complete) complete(sender, gesturePwd, GestureUnlockResultCreateFinalSuccess);
//                [self setGesturePwd:gesturePwd];
//                //清除标记
//                [self setCreateForModify:NO];
//                [self setTempString:nil];
//            }else{
//                NSLog(@"失败,请重试");
//                if (complete) complete(sender, gesturePwd, GestureUnlockResultCreateFailure);
//                [sender errorState];
//                return;
//            }
//        }
//        [sender normalState];
    }
    
    
//    if (endBlock) endBlock(sender, gesturePwd);
//    NSLog(@"修改");
}
+ (void)verifyWithView:(GestureUnlockView *)sender gesturePwd:(NSString *)gesturePwd{
    void(^complete)(GestureUnlockView * sender, NSString * gesturePwd, GestureUnlockResult result) = objc_getAssociatedObject(self, &kGestureUnlockResultKey);
    //根据手势结果和缓存的值相比对 如果相等 成功
        //如果失败 就显示错误
    if ([[self gesturePwd] isEqualToString:gesturePwd]) {
        NSLog(@"成功");
        if (complete) complete(sender, gesturePwd, GestureUnlockResultVerifySuccess);
        [sender normalState];
    } else {
        NSLog(@"失败");
        if (complete) complete(sender, gesturePwd, GestureUnlockResultVerifyFailure);
        [sender errorState];
    }
    
//    if (endBlock) endBlock(sender, gesturePwd);
    NSLog(@"校验");
}

+ (void)resetState {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:NO forKey:kGestureUnlockModify];
    [userDefault setBool:NO forKey:kGestureTrack];
    [userDefault setObject:nil forKey:kGestureUnlockPwd];
    [self setTempString:nil];
    [userDefault synchronize];
}
@end
