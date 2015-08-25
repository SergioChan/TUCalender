//
//  TUCalendarHeaderItemView.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUCalendarView.h"

@interface TUCalendarHeaderItemView : UIView

@property (weak, nonatomic) TUCalendarView *calendar;

@property (nonatomic, copy) void (^transferButtonPressed)(NSInteger type);

- (void)setCurrentDate:(NSDate *)currentDate;

- (void)reloadLayout;

@end
