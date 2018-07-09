//
//  GestureItem.h
//  Test_GestureUnlockView
//
//  Created by 李东波 on 6/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <UIKit/UIKit.h>

// 三种状态 正常 连线 错误状态
typedef NS_ENUM(NSInteger, GestureItemState) {
    GestureItemStateNormal,
    GestureItemStateConnect,
    GestureItemStateError,
};

@interface GestureItem : UIImageView

@property (nonatomic, assign)GestureItemState itemState;

@end
