//
//  CircleButton.h
//  ObjCTest
//
//  Created by Yun CHEN on 2018/8/8.
//  Copyright © 2018年 Yun CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EllipseButton : UIButton

@property(nonatomic,assign) NSInteger numberOfAnnulus;
@property(nonatomic,copy) NSArray<UIColor *> *colorsOfAnnulus;
@property(nonatomic,assign) CGFloat annulusWidth;

@end
