//
//  TUCalendarWeekView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarWeekView.h"

#import "TUCalendarDayView.h"

@interface TUCalendarWeekView (){
    NSArray *daysViews;
};

@end

@implementation TUCalendarWeekView

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
    
    for(int i = 0; i < 7; ++i){
        UIView *view = [TUCalendarDayView new];
        
        [views addObject:view];
        [self addSubview:view];
    }
    
    daysViews = views;
}

- (void)layoutSubviews
{
    CGFloat x = 0;
    CGFloat width = self.frame.size.width / 7.;
    CGFloat height = self.frame.size.height;
    
    for(UIView *view in self.subviews){
        view.frame = CGRectMake(x, 0, width, height);
        x = CGRectGetMaxX(view.frame);
    }
    
    [super layoutSubviews];
}

- (void)setBeginningOfWeek:(NSDate *)date
{
    NSDate *currentDate = date;
    
    NSCalendar *calendar = self.calendar.defaultCalendar;
    
    for(TUCalendarDayView *view in daysViews){
        [view setIsOtherMonth:NO];
        [view setDate:currentDate];
        
        NSDateComponents *dayComponent = [NSDateComponents new];
        dayComponent.day = 1;
        
        currentDate = [calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    }
}

#pragma mark - JTCalendarManager

- (void)setCalendarManager:(TUCalendarView *)calendar
{
    self->_calendar = calendar;
    for(TUCalendarDayView *view in daysViews){
        [view setCalendar:calendar];
    }
}

- (void)reloadData
{
    for(TUCalendarDayView *view in daysViews){
        [view reloadData];
    }
}

- (void)reloadLayout
{
    for(TUCalendarDayView *view in daysViews){
        [view reloadLayout];
    }
}
@end
