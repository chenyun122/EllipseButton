//
//  CircleButton.m
//  ObjCTest
//
//  Created by Yun CHEN on 2018/8/8.
//  Copyright © 2018年 Yun CHEN. All rights reserved.
//

#import "EllipseButton.h"

@interface EllipseButton() {
    CGFloat centerX,centerY,rX,rY;
    CAShapeLayer *ellipseLayer;
}

@end

IB_DESIGNABLE
@implementation EllipseButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit {
    _numberOfAnnulus = 2;
    _colorsOfAnnulus = @[[UIColor colorWithRed:40.0/255.0 green:203.0/255.0 blue:158.0/255.0 alpha:1.0],
                         [UIColor colorWithRed:166.0/255.0 green:219.0/255.0 blue:217.0/255.0 alpha:1.0]];
    _annulusWidth = 8.0;
    
    [self createEllipseLayer];
#if !TARGET_INTERFACE_BUILDER
    [self createAnnulus];
#endif

}

- (void)createEllipseLayer {
    if (ellipseLayer == nil) {
        ellipseLayer = [CAShapeLayer layer];
        ellipseLayer.path = [[UIBezierPath bezierPathWithOvalInRect:self.bounds] CGPath];
        ellipseLayer.fillColor = self.backgroundColor.CGColor;
        [self.layer insertSublayer:ellipseLayer atIndex:0];
    }
}


#pragma mark - Properties
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    rX = centerX = frame.size.width / 2.0;
    rY = centerY = frame.size.height / 2.0;
    
    if (_numberOfAnnulus > 0) {
        if (ellipseLayer.sublayers.count <= 0) {
            [self createAnnulus];
        }
        else{
            [self refreshAnnulus];
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:UIColor.clearColor];

    [self createAnnulus];
    ellipseLayer.fillColor = backgroundColor.CGColor;
}

- (void)setNumberOfAnnulus:(NSInteger)numberOfAnnulus {
    _numberOfAnnulus = numberOfAnnulus;
    [self createAnnulus];
}

- (void)setColorsOfAnnulus:(NSArray<UIColor *> *)colorsOfAnnulus {
    _colorsOfAnnulus = colorsOfAnnulus;
    [self refreshAnnulus];
}

- (void)setAnnulusWidth:(CGFloat)annulusWidth {
    _annulusWidth = annulusWidth;
    [self refreshAnnulus];
}


#pragma mark - Hit Testing
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat value = (point.x - centerX) * (point.x - centerX) / (rX * rX) + (point.y - centerY) * (point.y - centerY) / (rY * rY);
    if (value <= 1.0) {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setAlphaToAnnulus:0.3];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setAlphaToAnnulus:1.0];
    [super touchesEnded:touches withEvent:event];
}


#pragma mark - Annulus
- (void)createAnnulus {
    [ellipseLayer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    for (int i=0;i<self.numberOfAnnulus;i++) {
        CAShapeLayer *annulusLayer = [CAShapeLayer layer];
        [self applyAnnulusPathWithLayer:annulusLayer Index:i];
        [ellipseLayer addSublayer:annulusLayer];
    }
}

- (void)refreshAnnulus {
    for (int i=0;i<ellipseLayer.sublayers.count;i++) {
        CAShapeLayer *annulusLayer = (CAShapeLayer *)ellipseLayer.sublayers[i];
        [self applyAnnulusPathWithLayer:annulusLayer Index:i];
    }
}

- (void)applyAnnulusPathWithLayer:(CAShapeLayer *)annulusLayer Index:(NSInteger)i {
    CGFloat origin = i * _annulusWidth + _annulusWidth / 2.0;
    CGFloat widthReducing = i * _annulusWidth * 2 + _annulusWidth;
    
    CGRect rect = CGRectMake(origin, origin, self.bounds.size.width - widthReducing, self.bounds.size.height - widthReducing);
    annulusLayer.path = [[UIBezierPath bezierPathWithOvalInRect:rect] CGPath];
    annulusLayer.lineWidth = _annulusWidth;
    if (i < _colorsOfAnnulus.count) {
        annulusLayer.strokeColor = _colorsOfAnnulus[i].CGColor;
    }
    annulusLayer.fillColor = UIColor.clearColor.CGColor;
}

- (void)setAlphaToAnnulus:(CGFloat)alpha {
    for (int i=0;i<ellipseLayer.sublayers.count;i++) {
        CAShapeLayer *annulusLayer = (CAShapeLayer *)ellipseLayer.sublayers[i];
        UIColor *color = [[UIColor colorWithCGColor:annulusLayer.strokeColor] colorWithAlphaComponent:alpha];
        annulusLayer.strokeColor = color.CGColor;
    }
}

@end
