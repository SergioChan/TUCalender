//
//  ViewController.h
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUCalendarView.h"

@interface ViewController : UIViewController<TUCalendarDataSource>

@property (weak, nonatomic) IBOutlet TUCalendarHeaderView *TUcalendarHeaderView;
@property (weak, nonatomic) IBOutlet TUCalendarContentView *TUcalendarContentView;

@property (strong, nonatomic) TUCalendarView *calendar;

@end

