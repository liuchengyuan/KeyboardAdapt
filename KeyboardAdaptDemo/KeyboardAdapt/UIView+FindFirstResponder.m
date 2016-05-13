//
//  UIView+FindFirstResponder.m
//  Template
//
//  Created by 刘诚远 on 16/5/12.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "UIView+FindFirstResponder.h"

@implementation UIView (FindFirstResponder)

- (instancetype)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}

@end
