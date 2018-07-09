//
//  GestureUnlockView.m
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "GestureUnlockView.h"
//#import "GestureBtnItem.h"
#import "GestureItem.h"

//#import <objc/runtime.h>


//static char kGestureEndKey;

@interface GestureUnlockView()

@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, assign) BOOL isGesureEnd;

@end

@implementation GestureUnlockView

- (NSMutableArray *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
    }
    return _selectedItems;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}

- (void)removeFromSuperview {
    [GUManager setTempString:nil];
    [GUManager setCreateForModify:NO];
}

- (void)initSubViews {
    GUStyles * styles = [GUManager sharedStyle];
    
    CGFloat height = 0;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    int row = styles.row;
    int column = styles.column;
    self.lineColor = styles.lineNormalColor;
    
    CGFloat horizontalMargin = 70;//水平距离两边间距
    
    for (int i = 0; i < row * column; i++) {
        GestureItem * item = [[GestureItem alloc] init];
        item.userInteractionEnabled = NO;
        
        item.tag = 1000 + i;
        CGFloat x = 0,y = 0,w = 0,h = 0;
        
        if (width == 320) {
            w = 50;
            h = 50;
        } else {
            w = 58;
            h = 58;
        }
        CGFloat itemMargin = (width - w * row - (row -1) * horizontalMargin ) / (column - 1);
        
        CGFloat col = i % column;
        CGFloat rw = i / column;
        
        x = horizontalMargin + (w+itemMargin)*col;
        
        y = itemMargin + (w+itemMargin)*rw;
        
        item.frame = CGRectMake(x, y, w, h);
        [self addSubview:item];
        if (i == row * column -1) {
            height = y + h + itemMargin;
        }
    }
    self.bounds = CGRectMake(0, 0, width, height);
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    _currentPoint = [sender locationInView:self];
    [self setNeedsDisplay];
    
    for (GestureItem *item in self.subviews) {
        if (CGRectContainsPoint(item.frame, _currentPoint) && item.itemState == GestureItemStateNormal) {
            item.itemState = GestureItemStateConnect;
            [self.selectedItems addObject:item];
        }
    }
    [self layoutIfNeeded];
    
    //绘制结束按钮还原为默认的状态
    if (sender.state == UIGestureRecognizerStateEnded) {
        //保存输入密码
        NSMutableString *gesturePwd = [NSMutableString string];
        for (GestureItem *item in self.selectedItems) {
            [gesturePwd appendFormat:@"%ld",item.tag-1000];
            item.itemState = GestureItemStateNormal;
        }
//        [self.selectedItems removeAllObjects];
        
        NSLog(@"gesturePwd: %@", gesturePwd);
        //手势密码绘制完成后会掉
//        void(^endBlock)(GestureUnlockView * sender, NSString * gesturePwd)= objc_getAssociatedObject(self, &kGestureEndKey);
//        if (endBlock) endBlock(self, gesturePwd);
        [GUManager gestureUnlockEnd:self gesturePwd:gesturePwd];
        self.isGesureEnd = YES;
    }else{
        self.isGesureEnd = NO;
    }
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.selectedItems.count == 0) return;
    // 把所有选中按钮中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSUInteger count = self.selectedItems.count;
    for (int i = 0; i < count; i++) {
        GestureItem *item = self.selectedItems[i];
        if (i == 0) {
            //设置起点
            [path moveToPoint:item.center];
        }else {
            [path addLineToPoint:item.center];
        }
    }
    
    if (!_isGesureEnd) [path addLineToPoint:_currentPoint];
//    if ([[GDTFileUtils readPreferencesDataForKey:gesturesPasswordTrackKey] isEqualToString:@"1"]) {
//        //        [[UIColor redColor]set];
////        [UIColorHex(0x08A3EE) set];
//    } else {
//        [[UIColor clearColor]set];
//    }
//    NSLog(@"%@", [GUManager showGestureTrack]?@"显示":@"隐藏");
//    NSLog(@"%@",self.lineColor);
    
    self.lineColor = [GUManager showGestureTrack]?(self.lineColor != [UIColor clearColor]?self.lineColor:[[GUManager sharedStyle] lineNormalColor]):[UIColor clearColor];
    [self.lineColor set];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 2;
    [path stroke];
}

- (void)normalState {
    [self.selectedItems removeAllObjects];
    self.lineColor = [GUManager showGestureTrack]?[GUManager sharedStyle].lineNormalColor:[UIColor clearColor];
    [self setNeedsDisplay];
}
- (void)errorState {
    for (GestureItem * item in self.selectedItems) {
        item.itemState = GestureItemStateError;
    }
    self.lineColor = [GUManager sharedStyle].lineErrorColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (GestureItem * item in self.selectedItems) {
            item.itemState = GestureItemStateNormal;
        }
        
        self.lineColor = [GUManager showGestureTrack]?[GUManager sharedStyle].lineNormalColor:[UIColor clearColor];
        [self.selectedItems removeAllObjects];
        [self setNeedsDisplay];
    });
}


#pragma mark -

//- (void)gestureUnlockViewRecognizerStateEnded:(void(^)(GestureUnlockView * sender, NSString * gesturePwd))endBlock {
//    objc_setAssociatedObject(self, &kGestureEndKey, endBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

@end
