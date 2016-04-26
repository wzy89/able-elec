//
//  BRButton.m
//  BRButtonDemo
//
//  Created by Yang on 16/3/1.
//  Copyright © 2016年 BokkkRottt. All rights reserved.
//

#import "ABButton.h"

typedef NS_ENUM(NSUInteger, ABButtonBackgroundState)
{
    ABButtonBackgroundStateNone     = 0,
    ABButtonBackgroundStateImage    = 1,
    ABButtonBackgroundStateColor    = 2,
};

@interface ABButton ()
{
    NSImageView *_backgroundImageView;
    NSTextField *_titleTF;

    ABButtonBackgroundState _bgState;
    
    BOOL _isClicked;
    BOOL _mouseDown;
    BOOL _mouseIn;
}
@property (nonatomic, assign) ABButtonState state;

@property (readonly) NSColor *effectBackgroundColor;

@property (readonly) NSImage *effectBackgroundImage;

@property (retain) NSTrackingArea *trackingArea;

@end

@implementation ABButton

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}
- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setFrame:(NSRect)frame
{
    [super setFrame:frame];
    _backgroundImageView.frame = self.bounds;
    CGFloat hight = _titleFont.pointSize;
    _titleTF.frame = CGRectMake(0, (frame.size.height-hight-2)/2, frame.size.width, hight+2);
}
- (void)setup
{
    _mouseDown = NO;
    _mouseIn = NO;
    _isClicked = NO;
    _backgroundImageView = [[NSImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.imageScaling = NSImageScaleAxesIndependently;
    _backgroundImageView.hidden = YES;
    [self addSubview:_backgroundImageView];
    
    _titleTF = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [_titleTF setBordered: NO];
    [_titleTF setDrawsBackground: NO];
    _titleTF.editable = NO;
    _titleTF.alignment = NSTextAlignmentCenter;
    [_titleTF setFocusRingType: NSFocusRingTypeNone];
    _titleTF.textColor = [NSColor blackColor];
    [self addSubview:_titleTF];
    
    _selected = NO;
    _title = @"";
    _bgState = ABButtonBackgroundStateNone;
    self.state = ABButtonStateDefault;
    
    self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}
-(void)setBackground
{
    switch (_bgState)
    {
        case ABButtonBackgroundStateImage:
            {
                if(!_effectBackgroundImage)break;
                _backgroundImageView.hidden = NO;
                _backgroundImageView.image = _effectBackgroundImage;
            }
            break;
        case ABButtonBackgroundStateColor:
            {
                if (!_effectBackgroundColor)break;
                _backgroundImageView.hidden = YES;
                self.wantsLayer = YES;
                self.layer.backgroundColor = _effectBackgroundColor.CGColor;
            }
            break;
        default:
            break;
    }
}
-(BOOL)hasState:(ABButtonState)state
{
    BOOL hasState = NO;
    switch (state)
    {
        case ABButtonStateDisabled:
            hasState = _disabledBackgroundImage||_disabledBackgroundColor;
            break;
        case ABButtonStateHighLighted:
            hasState = _highLightedBackgroundImage||_highLightedBackgroundColor;
            break;
        case ABButtonStateMouseDown:
            hasState = _mouseDownBackgroundImage||_mouseDownBackgroundColor;
            break;
        case ABButtonStateNormal:
            hasState = _normalBackgroundImage||_normalBackgroundColor;
            break;
        case ABButtonStateSelected:
            hasState = _selectedBackgroundImage||_selectedBackgroundColor;
            break;
        default:
            break;
    }
    return hasState;
}
#pragma mark --公共方法--
- (void)addTarget:(id)target action:(SEL)action
{
    if (target && action && [target respondsToSelector:action])
    {
        self.target = target;
        self.clickAction = action;
    }
}
-(void)setBackgroundColor:(NSColor *)color forState:(ABButtonState)state
{
    if (!color) return;
    _bgState = ABButtonBackgroundStateColor;
    switch (state)
    {
        case ABButtonStateDisabled:
            _disabledBackgroundColor = color;
            break;
        case ABButtonStateHighLighted:
            _highLightedBackgroundColor = color;
            break;
        case ABButtonStateMouseDown:
            _mouseDownBackgroundColor = color;
            break;
        case ABButtonStateNormal:
        {
            _normalBackgroundColor = color;
            self.state = ABButtonStateNormal;
        }
            break;
        case ABButtonStateSelected:
            _selectedBackgroundColor = color;
            break;
        default:
            break;
    }
}
-(void)setBackgroundImage:(NSImage *)image forState:(ABButtonState)state
{
    if (!image) return;
    _bgState = ABButtonBackgroundStateImage;
    switch (state)
    {
        case ABButtonStateDisabled:
            _disabledBackgroundImage = image;
            break;
        case ABButtonStateHighLighted:
            _highLightedBackgroundImage = image;
            break;
        case ABButtonStateMouseDown:
            _mouseDownBackgroundImage = image;
            break;
        case ABButtonStateNormal:
        {
            _normalBackgroundImage = image;
            self.state = ABButtonStateNormal;
        }
            break;
        case ABButtonStateSelected:
            _selectedBackgroundImage = image;
            break;
        default:
            break;
    }
}
#pragma mark --鼠标操作--
- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.enabled)
    {
        _mouseDown = YES;
        self.state = ABButtonStateMouseDown;
    }
}
- (void)mouseUp:(NSEvent *)theEvent
{
    if (self.enabled)
    {
        if (_mouseDown)
        {
            _mouseDown = NO;
            if (_mouseIn)
            {
                _isClicked = YES;
                self.selected = !_selected;
                if (self.target && self.clickAction)
                    [self.target performSelector:self.clickAction withObject:self afterDelay:0.2];
            }else
            {
                _isClicked = NO;
                self.selected = _selected;
            }
        }
    }
}
- (void)mouseEntered:(NSEvent *)theEvent
{
    if (self.enabled)
    {
        _mouseIn = YES;
        if (!_selected||![self hasState:ABButtonStateSelected])
        {
            if (!_mouseDown)
                self.state = ABButtonStateHighLighted;
            else
                self.state = ABButtonStateMouseDown;
        }
        if (self.target && self.moveInAction)
        {
            [self.target performSelector:self.moveInAction withObject:self afterDelay:0.0];
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (self.enabled)
    {
        _mouseIn = NO;
        if (!_selected||![self hasState:ABButtonStateSelected])
        {
            if (_mouseDown)
                self.state = ABButtonStateHighLighted;
            else
                self.state = ABButtonStateNormal;
        }
        if (self.target && self.moveOutAction)
        {
            [self.target performSelector:self.moveOutAction withObject:self afterDelay:0.0];
        }
    }
}
#pragma mark --set方法--
-(void)setState:(ABButtonState)state
{
    switch (state)
    {
        case ABButtonStateDisabled:
        {
            if (state == _state)break;
            if ([self hasState:ABButtonStateDisabled])
            {
                _effectBackgroundColor = _disabledBackgroundColor;
                _effectBackgroundImage = _disabledBackgroundImage;
            }else
            {
                if ([self hasState:ABButtonStateNormal])
                {
                    _effectBackgroundColor = _normalBackgroundColor;
                    _effectBackgroundImage = _normalBackgroundImage;
                }
            }
            [self setBackground];
        }
            break;
        case ABButtonStateHighLighted:
        {
            if (state == _state)break;
            if ([self hasState:ABButtonStateHighLighted])
            {
                _effectBackgroundColor = _highLightedBackgroundColor;
                _effectBackgroundImage = _highLightedBackgroundImage;
            }else
            {
                if ([self hasState:ABButtonStateNormal])
                {
                    _effectBackgroundColor = _normalBackgroundColor;
                    _effectBackgroundImage = _normalBackgroundImage;
                }
            }
            [self setBackground];
        }
            break;
        case ABButtonStateMouseDown:
        {
            if (state == _state)break;
            if ([self hasState:ABButtonStateMouseDown])
            {
                _effectBackgroundColor = _mouseDownBackgroundColor;
                _effectBackgroundImage = _mouseDownBackgroundImage;
            }else
            {
                if ([self hasState:ABButtonStateHighLighted])
                {
                    _effectBackgroundColor = _highLightedBackgroundColor;
                    _effectBackgroundImage = _highLightedBackgroundImage;
                }else
                {
                    if ([self hasState:ABButtonStateNormal])
                    {
                        _effectBackgroundColor = _normalBackgroundColor;
                        _effectBackgroundImage = _normalBackgroundImage;
                    }
                }
            }
            [self setBackground];
        }
            break;
        case ABButtonStateNormal:
        {
            if ([self hasState:ABButtonStateNormal])
            {
                _effectBackgroundColor = _normalBackgroundColor;
                _effectBackgroundImage = _normalBackgroundImage;
            }
            [self setBackground];
        }
            break;
        case ABButtonStateSelected:
        {
            if (state == _state)break;
            if ([self hasState:ABButtonStateSelected])
            {
                _effectBackgroundColor = _selectedBackgroundColor;
                _effectBackgroundImage = _selectedBackgroundImage;
            }else
            {
                if ([self hasState:ABButtonStateNormal])
                {
                    _effectBackgroundColor = _normalBackgroundColor;
                    _effectBackgroundImage = _normalBackgroundImage;
                }
            }
            [self setBackground];
        }
            break;
        default:
            break;
    }
}
-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (!enabled)
    {
        self.state = ABButtonStateDisabled;
    }else
    {
        if (_selected)
            self.state = ABButtonStateSelected;
        else
            self.state =ABButtonStateNormal;
    }
}
-(void)setSelected:(BOOL)selected
{
    if (self.enabled)
    {
        _selected = selected;
        if (selected)
        {
            self.state = ABButtonStateSelected;
        }else
        {
            self.state = ABButtonStateNormal;
        }
    }
}
-(void)setTitle:(NSString *)title
{
    if (!title) return;
    if ([_title isEqualToString:title]) return;
    _title = title;
    if (!_titleFont)
        self.titleFont = [NSFont systemFontOfSize:self.bounds.size.height-2];
    _titleTF.stringValue = title;
}
-(void)setTitleColor:(NSColor *)titleColor
{
    if (!titleColor) return;
    if (_titleColor == titleColor) return;
    _titleColor = titleColor;
    _titleTF.textColor = titleColor;
}
-(void)setTitleFont:(NSFont *)titleFont
{
    if (!titleFont) return;
    if (_titleFont == titleFont) return;
    _titleFont = titleFont;
    CGFloat hight = titleFont.pointSize;
    _titleTF.frame = CGRectMake(0, (self.frame.size.height-hight-2)/2, self.frame.size.width, hight+2);
    _titleTF.font = titleFont;
}
- (void)updateTrackingAreas
{
    if (self.trackingArea) {
        [self removeTrackingArea:self.trackingArea];
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingEnabledDuringMouseDrag owner:self userInfo:nil];
        [self addTrackingArea:self.trackingArea];
    }
}
@end
