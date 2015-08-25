//
//  TUCalendarDayView.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUCalendarView.h"

@interface TUCalendarDayView : UIView

@property (weak, nonatomic) TUCalendarView *calendar;

@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) BOOL isOtherMonth;

- (void)reloadData;

@end
