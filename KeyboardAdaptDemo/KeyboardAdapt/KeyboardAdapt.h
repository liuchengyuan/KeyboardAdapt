//
//  KeyboardAdapt.h
//  Template
//
//  Created by 刘诚远 on 16/5/10.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KeyboardAdapt : NSObject

//键盘适应         YES(开启)  NO(关闭)
@property (nonatomic, assign) BOOL FAdaptStartBool;

//点击空白处隐藏键盘 YES(开启) NO(关闭)
@property (nonatomic, assign) BOOL FTapHiddenBool;

//拖拽视图隐藏键盘 YES(开启) NO(关闭)
@property (nonatomic, assign) BOOL FDraggingHiddenBool;

+ (KeyboardAdapt *)keyboardAdapt;

@end
