//
//  TUCalendarMonthView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarMonthView.h"

#import "TUCalendarWeekTitleView.h"
#import "TUCalendarWeekView.h"

#define WEEKS_TO_DISPLAY 6

@interface TUCalendarMonthView (){
    TUCalendarWeekTitleView *weekdaysView;
    NSArray *weeksViews;
    
    NSUInteger currentMonthIndex;
};

@end

@implementation TUCalendarMonthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    NSMutableArray *views = [NSMutableArray new];
    
    {
        weekdaysView = [TUCalendarWeekTitleView new];
        [self addSubview:weekdaysView];
    }
    
    for(int i = 0; i < WEEKS_TO_DISPLAY; ++i){
        UIView *view = [TUCalendarWeekView new];
        
        [views addObject:view];
        [self addSubview:view];
    }
    
    weeksViews = views;
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
    CGFloat weeksToDisplay;
    weeksToDisplay = (CGFloat)(WEEKS_TO_DISPLAY + 1); // + 1 for weekDays
    
    CGFloat y = 0;
    CGFloat width = self.width;
    CGFloat height = self.height / weeksToDisplay;
    
    for(int i = 0; i < self.subviews.count; ++i){
        UIView *view = self.subviews[i];
        
        view.frame = CGRectMake(0, y, width, height);
        y = CGRectGetMaxY(view.frame);
    }
}

- (void)setBeginningOfMonth:(NSDate *)date
{
    NSDate *currentDate = date;
    
    NSCalendar *calendar = self.calendar.defaultCalendar;
    
    {
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
        
        currentMonthIndex = comps.month;
        
        // Hack
        if(comps.day > 7){
            currentMonthIndex = (currentMonthIndex % 12) + 1;
        }
    }
    
    for(TUCalendarWeekView *view in weeksViews){
        view.currentMonthIndex = currentMonthIndex;
        [view setBeginningOfWeek:currentDate];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 7;
        
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
}

#pragma mark - JTCalendarManager

- (void)setCalendar:(TUCalendarView *)calendar
{
    self->_calendar = calendar;
    
    [weekdaysView setCalendar:calendar];
    for(TUCalendarWeekView *view in weeksViews){
        [view setCalendar:calendar];
    }
}

- (void)reloadData
{
    for(TUCalendarWeekView *view in weeksViews){
        [view reloadData];
    }
}

- (void)reloadLayout
{
    [self configureConstraintsForSubviews];

    [TUCalendarWeekTitleView beforeReloadLayout];
    [weekdaysView reloadLayout];
    
    for(TUCalendarWeekView *view in weeksViews){
        [view reloadLayout];
    }
}

@end
