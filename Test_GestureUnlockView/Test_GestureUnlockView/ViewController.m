//
//  ViewController.m
//  Test_GestureUnlockView
//
//  Created by 李东波 on 5/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "ViewController.h"
#import "BezierPathView.h"
#import "GestureUnlockView.h"
@interface ViewController ()

@property (nonatomic, strong)BezierPathView * bView;

@property (nonatomic, strong)GestureUnlockView * unlockView;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    BezierPathView * bView = [BezierPathView new];
//    bView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 300);
//    [self.view addSubview:bView];
//    bView.backgroundColor = [UIColor lightTextColor];
//    self.bView = bView;
    
    
    self.unlockView = [[GestureUnlockView alloc] init];
    self.unlockView.backgroundColor = [UIColor lightTextColor];
    [self.view addSubview:_unlockView];
    self.unlockView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 300);
//    [GUManager gestureUnlockEnd:^(GestureUnclokViewState state, NSString *gesturePwd) {
//        NSLog(@"结果: %@", gesturePwd);
//    }];
//    [GUManager gestureUnlockEndWithState:GestureUnclokViewStateModify endBlock:^(GestureUnlockView *sender, NSString *gesturePwd) {
//        NSLog(@"%@", gesturePwd);
//    }];
    self.showBtn.selected = [GUManager showGestureTrack];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeColor:(id)sender {
    
//    [_bView changeColor];
//    UIButton * btn = sender;
//    btn.selected = !btn.selected;
//    _bView.bColor = btn.selected?[UIColor blueColor]: [UIColor redColor];
//    [_bView setNeedsDisplay];
    
    [GUManager gestureUnlockEndWithState:GestureUnlockViewStateCreate complete:^(GestureUnlockView *sender, NSString *gesturePwd, GestureUnlockResult result) {
        NSLog(@"创建 gesturePwd: %@ result: %d",gesturePwd,result);
    }];
    
    
}

- (IBAction)modify:(id)sender {
    [GUManager gestureUnlockEndWithState:GestureUnlockViewStateModify complete:^(GestureUnlockView *sender, NSString *gesturePwd, GestureUnlockResult result) {
        NSLog(@"修改 gesturePwd: %@ result: %d",gesturePwd,result);
    }];
}

- (IBAction)verify:(id)sender {
    
    [GUManager gestureUnlockEndWithState:GestureUnlockViewStateModify complete:^(GestureUnlockView *sender, NSString *gesturePwd, GestureUnlockResult result) {
        NSLog(@"校验 gesturePwd: %@ result: %d",gesturePwd,result);
    }];
    
}
- (IBAction)clean:(id)sender {
    [GUManager resetState];
}

- (IBAction)Track:(id)sender {
    UIButton * btn = sender;
    btn.selected = !btn.selected;
    [GUManager setGestureTrackStatus:btn.selected];
}




@end
