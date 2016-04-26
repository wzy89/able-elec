//
//  BRButton.h
//  BRButtonDemo
//
//  Created by Yang on 16/3/1.
//  Copyright © 2016年 BokkkRottt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, ABButtonState)
{
    ABButtonStateNormal         = 0,
    ABButtonStateHighLighted    = 1,
    ABButtonStateMouseDown      = 2,
    ABButtonStateSelected       = 3,
    ABButtonStateDisabled       = 4,
    ABButtonStateDefault        = 12
};

@interface ABButton : NSControl

//状态
@property (nonatomic, assign) BOOL selected;

//标题
@property (nonatomic, copy) NSString * title;

@property (nonatomic, retain) NSColor * titleColor;

@property (nonatomic, strong) NSFont * titleFont;

//背景图片
@property (nonatomic, readonly) NSImage *disabledBackgroundImage;

@property (nonatomic, readonly) NSImage *normalBackgroundImage;       //正常

@property (nonatomic, readonly) NSImage *highLightedBackgroundImage;  //高亮

@property (nonatomic, readonly) NSImage *mouseDownBackgroundImage;    //鼠标按下

@property (nonatomic, readonly) NSImage *selectedBackgroundImage;     //选中

//背景颜色
@property (nonatomic, readonly) NSColor *disabledBackgroundColor;

@property (nonatomic, readonly) NSColor *normalBackgroundColor;       //正常

@property (nonatomic, readonly) NSColor *highLightedBackgroundColor;  //高亮

@property (nonatomic, readonly) NSColor *mouseDownBackgroundColor;    //鼠标按下

@property (nonatomic, readonly) NSColor *selectedBackgroundColor;     //选中

//响应事件
@property (nonatomic) SEL clickAction;

@property (nonatomic) SEL moveInAction;

@property (nonatomic) SEL moveOutAction;

- (void)addTarget:(id)target action:(SEL)action;

//设置对应状态的图片和背景颜色
- (void)setBackgroundImage:(NSImage *)image forState:(ABButtonState)state;

- (void)setBackgroundColor:(NSColor *)color forState:(ABButtonState)state;

@end
