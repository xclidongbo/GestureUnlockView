//
//  BezierPathView.m
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "BezierPathView.h"


@interface BezierPathView ();


@property (nonatomic, strong)CAShapeLayer * shapeLayer;
@end

@implementation BezierPathView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(200, 100)];
    [self.bColor?:[UIColor redColor] set];
    [path stroke];
//    self.path = path;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor lightTextColor];
    }
    return self;
}






//- (void)changeColor {
//    [self.path removeAllPoints];
//    UIBezierPath * path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(100, 100)];
//    [path addLineToPoint:CGPointMake(200, 100)];
//    [[UIColor blueColor] set];
//    [path stroke];
//    [self setNeedsLayout];
//}

@end
