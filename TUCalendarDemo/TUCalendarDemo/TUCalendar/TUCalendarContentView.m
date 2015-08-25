//
//  TUCalendarContentView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarContentView.h"

#import "TUCalendarView.h"

#import "TUCalendarMonthView.h"
#import "TUCalendarWeekView.h"

@interface TUCalendarContentView(){
    NSMutableArray *monthsViews;
}

@end

@implementation TUCalendarContentView

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
    monthsViews = [NSMutableArray new];
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.clipsToBounds = YES;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        TUCalendarMonthView *monthView = [TUCalendarMonthView new];
        [self addSubview:monthView];
        [monthsViews addObject:monthView];
    }
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    [super layoutSubviews];
}

- (void)configureConstraintsForSubviews
{
    self.contentOffset = CGPointMake(self.contentOffset.x, 0); // Prevent bug when contentOffset.y is negative
    
    CGFloat x = 0;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    for(UIView *view in monthsViews){
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }

    self.contentSize = CGSizeMake(width * NUMBER_PAGES_LOADED, height);
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    self->_currentDate = currentDate;
    
    NSCalendar *calendar = self.calendar.defaultCalendar;
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        TUCalendarMonthView *monthView = monthsViews[i];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        
        
        dayComponent.month = i - (NUMBER_PAGES_LOADED / 2);
        NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
        monthDate = [self beginningOfMonth:monthDate];
        [monthView setBeginningOfMonth:monthDate];
    }
}

- (NSDate *)beginningOfMonth:(NSDate *)date
{
    NSCalendar *calendar = self.calendar.defaultCalendar;
    NSDateComponents *componentsCurrentDate = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.weekday = calendar.firstWeekday;
    
    return [calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)beginningOfWeek:(NSDate *)date
{
    NSCalendar *calendar = self.calendar.defaultCalendar;
    NSDateComponents *componentsCurrentDate = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = componentsCurrentDate.weekOfMonth;
    componentsNewDate.weekday = calendar.firstWeekday;
    
    return [calendar dateFromComponents:componentsNewDate];
}

#pragma mark - TUCalendarView

- (void)setCalendar:(TUCalendarView *)calendar
{
    self->_calendar = calendar;
    
    for(TUCalendarMonthView *view in monthsViews){
        [view setCalendar:calendar];
    }
}

- (void)reloadData
{
    for(TUCalendarMonthView *monthView in monthsViews){
        [monthView reloadData];
    }
}

- (void)reloadLayout
{
    // Fix when change mode during scroll
    self.scrollEnabled = YES;
    
    for(TUCalendarMonthView *monthView in monthsViews){
        [monthView reloadLayout];
    }
}

@end
