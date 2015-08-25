//
//  TUCalendarHeaderView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarHeaderView.h"

#import "TUCalendarView.h"
#import "TUCalendarHeaderItemView.h"

@interface TUCalendarHeaderView(){
    NSMutableArray *monthsViews;
}

@end

@implementation TUCalendarHeaderView

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
        TUCalendarHeaderItemView *monthView = [TUCalendarHeaderItemView new];
        
        __weak TUCalendarHeaderView *weakSelf = self;
        monthView.transferButtonPressed = ^(NSInteger selected){
            if(weakSelf.transferButtonPressed)
            {
                weakSelf.transferButtonPressed(selected);
            }
        };
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
    CGFloat width = self.width;
    CGFloat height = self.height;

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
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    for(int i = 0; i < NUMBER_PAGES_LOADED; ++i){
        TUCalendarHeaderItemView *monthView = monthsViews[i];
        
        dayComponent.month = i - (NUMBER_PAGES_LOADED / 2);
        NSDate *monthDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
        [monthView setCurrentDate:monthDate];
    }
}

#pragma mark - TUCalendarView

- (void)setCalendar:(TUCalendarView *)calendar
{
    self->_calendar = calendar;
    
    for(TUCalendarHeaderItemView *view in monthsViews){
        [view setCalendar:calendar];
    }
}

- (void)reloadLayout
{
    self.scrollEnabled = NO;
    
    [self configureConstraintsForSubviews];
    for(TUCalendarHeaderItemView *view in monthsViews){
        [view reloadLayout];
    }
}

@end
