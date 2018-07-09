//
//  GestureItem.m
//  Test_GestureUnlockView
//
//  Created by 李东波 on 6/7/2018.
//  Copyright © 2018 李东波. All rights reserved.
//

#import "GestureItem.h"
#import "GUManager.h"

@implementation GestureItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.image =self.image?:[GUManager sharedStyle].normalImg;
    }
    return self;
}

- (void)setItemState:(GestureItemState)itemState {
    switch (itemState) {
        case GestureItemStateNormal:
            self.image =[GUManager sharedStyle].normalImg;
            break;
        case GestureItemStateConnect:
            self.image = [GUManager sharedStyle].connectImg;
            break;
        case GestureItemStateError:
            self.image = [GUManager sharedStyle].errorImg;
            break;
        default:
            break;
    }
    _itemState = itemState;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
