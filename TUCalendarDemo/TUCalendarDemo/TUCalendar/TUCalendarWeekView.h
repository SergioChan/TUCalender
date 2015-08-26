//
//  TUCalendarWeekView.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUCalendarView.h"

@interface TUCalendarWeekView : UIView
@property (weak, nonatomic) TUCalendarView *calendar;
@property (assign, nonatomic) NSUInteger currentMonthIndex;
- (void)setBeginningOfWeek:(NSDate *)date;
- (void)reloadData;
- (void)reloadLayout;

@end
