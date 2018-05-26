//
//  NSLayoutConstraint+Multiplier.m
//  Schenley
//
//  Created by songshushan on 2018/5/18.
//  Copyright © 2018年 sqhtech. All rights reserved.
//

#import "NSLayoutConstraint+Multiplier.h"

@implementation NSLayoutConstraint (Multiplier)

- (instancetype)setMultiplier:(CGFloat)multiplier{
    [NSLayoutConstraint deactivateConstraints:@[self]];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondItem attribute:self.secondAttribute multiplier:multiplier constant:self.constant];
    [NSLayoutConstraint activateConstraints:@[constraint]];
    return constraint;
}

@end
