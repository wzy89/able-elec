//
//  AppDelegate.m
//  ABButtonDemo
//
//  Created by 王朝阳 on 16/4/21.
//  Copyright © 2016年 Risun. All rights reserved.
//

#import "AppDelegate.h"
#import "ABButton.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic,strong)ABButton *button;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSRect rect = self.window.frame;
    _button = [[ABButton alloc] initWithFrame:CGRectMake(rect.size.width/2-50, rect.size.height/2-20, 100, 40)];
    [_button setBackgroundColor:[NSColor lightGrayColor] forState:ABButtonStateNormal];
    [_button setBackgroundColor:[NSColor redColor] forState:ABButtonStateHighLighted];
    [_button setBackgroundColor:[NSColor blueColor] forState:ABButtonStateMouseDown];
    [_button setBackgroundColor:[NSColor greenColor] forState:ABButtonStateSelected];
    _button.tag = 4;
    _button.target = self;
    _button.title = @"慢慢点击";
    _button.titleFont = [NSFont systemFontOfSize:14.0f];
    _button.clickAction = @selector(clickBtnAction:);
    _button.moveInAction = @selector(mouseInAction:);
    _button.moveOutAction = @selector(mouseOutAction:);
    
    [self.window.contentView addSubview:_button];
}
-(void)mouseInAction:(ABButton *)sender
{
    NSLog(@"btn_tag = %li 鼠标移入",sender.tag);
}
-(void)mouseOutAction:(ABButton *)sender
{
    NSLog(@"btn_tag = %li 鼠标移出",sender.tag);
}
-(void)clickBtnAction:(ABButton *)sender
{
    NSLog(@"btn_tag = %li 鼠标点击",sender.tag);
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
