//
//  KeyboardAdapt.m
//  Template
//
//  Created by 刘诚远 on 16/5/10.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "KeyboardAdapt.h"

#import "UIView+FindFirstResponder.h"

@interface KeyboardAdapt() <UIScrollViewDelegate>
{
    //点击空白处隐藏键盘手势
    UITapGestureRecognizer *FTapGesture;
   
    UIScrollView *a;
    
    //记录标志
    BOOL FRecordSign;
    
    //记录滚动范围
    CGSize FRecordSize;
    
    //记录滚动视图代理
    id FRecordDelegate;
}

@end

@implementation KeyboardAdapt

//获取单利
+ (KeyboardAdapt *)keyboardAdapt {
    static KeyboardAdapt *keyboardAdapt = nil;
    
    if (keyboardAdapt == nil)  {
        
        keyboardAdapt = [[KeyboardAdapt alloc] init];
        
        keyboardAdapt->FTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:keyboardAdapt action:@selector(tapHiddenKeyboard)];
        
        keyboardAdapt->FRecordSign = NO;
    }
    
    return keyboardAdapt;
}

/*
 *功能:键盘适应
 *参数:
 *      FAdaptStartBool YES(开启)  NO(关闭)
 */
- (void)setFAdaptStartBool:(BOOL)FAdaptStartBool {
    if (FAdaptStartBool) {
        [[NSNotificationCenter defaultCenter]  addObserver:self
                                                  selector:@selector(KeyboardChange:)
                                                      name:UIKeyboardWillChangeFrameNotification
                                                    object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

#pragma mark - 监听触发
//键盘监听触发
- (void)KeyboardChange:(NSNotification*)notification {
    
    //键盘属性
    NSDictionary *infoDictionary = [notification userInfo];
    
    //键盘当前框架
    CGRect endRect = [[infoDictionary objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //键盘响应视图
     UIView *firstResponderView = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(findFirstResponder)];
    
    //键盘响应视图---相对屏幕坐标
    CGPoint relativeWindowPoint = [firstResponderView convertPoint:CGPointMake(0, 0) toView:[[UIApplication sharedApplication] keyWindow]];
    if ([firstResponderView isKindOfClass:[UITextView class]]) {
        
        UITextView *textView = (UITextView *)firstResponderView;
        
        relativeWindowPoint.y += textView.contentOffset.y;
    }
    
    //获取键盘响应--显示视图
    UIView *superView = [self getFirstResponderSuperView:firstResponderView];
    
    //添加点击空白处隐藏键盘
    [self addtapHiddenKeyboard];
    
    //YES 显示键盘    NO隐藏键盘
    BOOL hiddenBool = endRect.origin.y < [UIScreen mainScreen].bounds.size.height ? YES : NO;
    
    //键盘响应视图---相对屏幕,底边Y+5坐标
    CGFloat maxY = relativeWindowPoint.y + firstResponderView.frame.size.height + 5;
    
    //显示键盘
    if (hiddenBool) {
        
        if ([superView isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *scrollView = (UIScrollView *)superView;
            
            //保存原始状态
            if (!FRecordSign) {
                
                FRecordSign = YES;
                
                FRecordSize = scrollView.contentSize;
                
                if (_FDraggingHiddenBool) {
                    
                    FRecordDelegate = scrollView.delegate;
                    
                    [scrollView setDelegate:self];
                }
            }
            
            //设置滚动范围
            CGSize size = FRecordSize;
            
            if (size.height < scrollView.frame.size.height) {
                
                size.height = scrollView.frame.size.height;
            }
            
            size.height += endRect.size.height;
            
            scrollView.contentSize = size;
        }

        
        if (endRect.origin.y >= maxY) {
            return;
        }
        
        if ([superView isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *scrollView = (UIScrollView *)superView;
            
            CGFloat OffsetY = scrollView.contentOffset.y + (maxY - endRect.origin.y);
            
            [scrollView setContentOffset:CGPointMake(0, OffsetY) animated:YES];
        }
        else {
            
            CGRect superRect = superView.frame;
            
            superRect.origin.y -= maxY - endRect.origin.y;
            
            superView.frame = superRect;
        }
    }
    //隐藏键盘---还原视图
    else {
        
        if ([superView isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *scrollView = (UIScrollView *)superView;
            
             if (!FRecordSign) {
                 return;
             }
            
            FRecordSign = NO;
            
            //还原框架
            [scrollView setContentSize:FRecordSize];
            
            //还原代理
            if (_FDraggingHiddenBool) {
                
                [scrollView setDelegate:FRecordDelegate];
            }
        }
        else {
            
            CGRect superRect = superView.frame;
            
            superRect.origin.y = 0;
            
            superView.frame = superRect;
        }
    }
}

#pragma mark - 自定义私有方法
//获取键盘响应--显示视图
- (UIView *)getFirstResponderSuperView:(UIView *)firstResponderView {
    
    UIView *superView = firstResponderView.superview;
    
    while (1) {
        if ([superView isKindOfClass:[UIScrollView class]]) {
            break;
        }
        else if ([superView.superview isKindOfClass:[UIWindow class]] ||  [NSStringFromClass([superView.superview class]) isEqual:@"UIViewControllerWrapperView"]) {
            break;
        }
        
        superView = superView.superview;
    }
    
    return superView;
}

//添加点击事件(点击空白处隐藏键盘)
- (void)addtapHiddenKeyboard {
    
    if (_FTapHiddenBool) {
        
        //键盘响应视图
        UIView *firstResponderView = [[[UIApplication sharedApplication] keyWindow] performSelector:@selector(findFirstResponder)];
        
        //键盘响应--显示视图
        UIView *superView = firstResponderView.superview;
        while (1) {
            
            if ([superView.superview isKindOfClass:[UIWindow class]] ||  [NSStringFromClass([superView.superview class]) isEqual:@"UIViewControllerWrapperView"]) {
                break;
            }
            
            superView = superView.superview;
        }
        
        [superView addGestureRecognizer:FTapGesture];
    }
    else {
        [FTapGesture removeTarget:self action:@selector(tapHiddenKeyboard)];
    }
}

#pragma mark - UIScrollViewDelegate
//拖拽开始--隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 手势触发
//点击空白处隐藏键盘触发
- (void)tapHiddenKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
