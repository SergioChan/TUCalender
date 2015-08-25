//
//  TUCalendarHeaderView.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUCalendarView;

@interface TUCalendarHeaderView : UIScrollView

@property (weak, nonatomic) TUCalendarView *calendar;

@property (nonatomic, copy) void (^transferButtonPressed)(NSInteger type);

@property (strong, nonatomic) NSDate *currentDate;

- (void)reloadLayout;

@end
