//
//  TUCalendarDataCache.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUCalendarView;

@interface TUCalendarDataCache : NSObject
@property (weak, nonatomic) TUCalendarView *calendar;
- (void)reloadData;
- (BOOL)haveCheckedin:(NSDate *)date;

@end
