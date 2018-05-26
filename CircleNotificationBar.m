//
//  CircleNotificationBar.m
//  Schenley
//
//  Created by songshushan on 2018/5/18.
//  Copyright © 2018年 sqhtech. All rights reserved.
//

#import "CircleNotificationBar.h"
#import "NSLayoutConstraint+Multiplier.h"

@interface CircleNotificationBar()
{
    NSInteger _displayNumber;
    NSInteger _displayIndex;
}

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *visiableArray;
@property (nonatomic, strong) NSMutableArray *reusableArray;
@property (nonatomic, strong) NSArray<NSString *> * dataArray;

@end

@implementation CircleNotificationBar

- (NSArray<NSString *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSArray array] init];
    }
    return _dataArray;
}

- (NSMutableArray *)visiableArray{
    if (_visiableArray == nil) {
        _visiableArray = [NSMutableArray array];
    }
    return _visiableArray;
}

- (NSMutableArray *)reusableArray{
    if (_reusableArray == nil) {
        _reusableArray = [NSMutableArray array];
    }
    return _reusableArray;
}

- (instancetype)init{
    if (self = [super init]) {
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)reloadTextLabel{
    __block NSInteger displayNumber = _displayNumber;
    UILabel * lastLabel = self.reusableArray[0];
    [self addSubview:lastLabel];
    [self setLayoutForTextLabel:lastLabel withIndex:displayNumber];
    lastLabel.clipsToBounds = YES;
    lastLabel.alpha = 0.0;
    lastLabel.text = self.dataArray[_displayIndex];
    _displayIndex ++;
    if (_displayIndex > self.dataArray.count - 1) {
        _displayIndex = 0;
    }
    [self.visiableArray addObject:lastLabel];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        for (int i = 0; i < self.visiableArray.count; i ++) {
            UILabel * textLabel = self.visiableArray[i];
            double ratioT = (i - 1)/((double)(displayNumber));
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.firstItem ==textLabel && constraint.firstAttribute == NSLayoutAttributeTop) {
                    if (ratioT == 0) ratioT = 0.001f;
                    constraint.multiplier = ratioT;
                }
            }
            textLabel.layer.masksToBounds = YES;
            textLabel.clipsToBounds = YES;
            if (i == 0) {
                textLabel.alpha = 0.0f;
            }else if (i == self.visiableArray.count - 1){
                textLabel.alpha = 1.0f;
            }
        }
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.reusableArray addObject:self.visiableArray.firstObject];
        UILabel * firstLabel = self.visiableArray[0];
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.firstItem ==firstLabel){
                [self removeConstraint:constraint];
            }
        }
        [firstLabel removeFromSuperview];
        [self.visiableArray removeObjectAtIndex:0];
        [self.reusableArray removeObjectAtIndex:0];
    }];
}


- (void)setupLabels{
    if ([self.dataSource respondsToSelector:@selector(numberOfDataSourceInCircleNotificationBar:)]) {
        _displayNumber = [self.dataSource numberOfDataSourceInCircleNotificationBar:self];
    }
    if ([self.dataSource respondsToSelector:@selector(dataSourceOfNotificationBar:)]) {
        self.dataArray = [self.dataSource dataSourceOfNotificationBar:self];
        if (self.dataArray.count == 0) return;
    }
    if(_displayNumber > self.dataArray.count){
        for (int i = 0; i < self.dataArray.count; i ++) {
            UILabel * textLabel = [[UILabel alloc] init];
            textLabel.textColor = UIColor.whiteColor;
            textLabel.text = self.dataArray[i];
            [self addSubview:textLabel];
            [self setLayoutForTextLabel:textLabel withIndex:i];
            [self.visiableArray addObject:textLabel];
        }
    }else{
        _displayIndex = 0;
        for (int i = 0; i < _displayNumber + 1; i ++) {
            UILabel * textLabel = [[UILabel alloc] init];
            textLabel.textColor = UIColor.whiteColor;
            if (i < _displayNumber) {
                textLabel.text = self.dataArray[_displayIndex];
                _displayIndex ++;
                [self addSubview:textLabel];
                [self setLayoutForTextLabel:textLabel withIndex:i];
                [self.visiableArray addObject:textLabel];
            }else{
                [self.reusableArray addObject:textLabel];
            }
        }
    }
}

//textLabel设置约束
- (void)setLayoutForTextLabel:(UILabel *)textLabel withIndex:(NSInteger)index{
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0f];
    NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0f];
    double ratioT = (index)/((double)(_displayNumber));
    if (ratioT == 0) ratioT = 0.001;//ratioT不能为0
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:ratioT constant:0.0];
    double ratioH = 1/((double)(_displayNumber));
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:(ratioH) constant:0.0];
    [self addConstraint:left];
    [self addConstraint:right];
    [self addConstraint:top];
    [self addConstraint:height];
}

- (void)reloadData{
    [self setupLabels];
    if (self.dataArray.count == 0) return;
    if (_displayNumber >= self.dataArray.count) return;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(reloadTextLabel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

@end
