//
//  TUCalendarContentView.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUCalendarView;

@interface TUCalendarContentView : UIScrollView
@property (weak, nonatomic) TUCalendarView *calendar;

@property (strong, nonatomic) NSDate *currentDate;

- (void)reloadData;
- (void)reloadLayout;
@end
