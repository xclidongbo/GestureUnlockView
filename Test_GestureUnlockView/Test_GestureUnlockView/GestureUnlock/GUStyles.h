//
//  GUStyles.h
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 定义样式
@interface GUStyles : NSObject

// btn 普通image
@property (nonatomic, strong)UIImage * normalImg;
// btn 连线image
@property (nonatomic, strong)UIImage * connectImg;
// btn errorimage
@property (nonatomic, strong)UIImage * errorImg;
// line 粗细
@property (nonatomic, assign)CGFloat lineWidth;
// line color
@property (nonatomic, strong)UIColor *lineNormalColor;
@property (nonatomic, strong)UIColor *lineErrorColor;
// 行
@property (nonatomic, assign)int row;
// 列
@property (nonatomic, assign)int column;

- (instancetype)initWithDefaultStyle NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end
