//
//  CircleNotificationBar.h
//  Schenley
//
//  Created by songshushan on 2018/5/18.
//  Copyright © 2018年 sqhtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleNotificationBar;

@protocol CircleNotificationBarDataSource<NSObject>

/**
 页面展示多少条数据
 */
- (NSInteger)numberOfDataSourceInCircleNotificationBar:(CircleNotificationBar *)circleNotificationBar;
/**
 数据资源
 */
- (NSArray<NSString *> *)dataSourceOfNotificationBar:(CircleNotificationBar *)circleNotificationBar;

@end

@interface CircleNotificationBar : UIView

@property (nonatomic, weak) id<CircleNotificationBarDataSource> dataSource;

- (void)reloadData;

@end
