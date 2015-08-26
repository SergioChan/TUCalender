//
//  TUCalendarWeekTitleView.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUCalendarView.h"

@interface TUCalendarWeekTitleView : UIView
@property (weak, nonatomic) TUCalendarView *calendar;
+ (void)beforeReloadLayout;
- (void)reloadLayout;
@end
