//
//  TUCalendarView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarView.h"

@interface TUCalendarView(){
}
@end

@implementation TUCalendarView

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.dayFormat = @"d";
    self.currentDate = [NSDate date];
    self->_dataCache = [TUCalendarDataCache new];
    self.dataCache.calendar = self;
    return self;
}

- (NSCalendar *)defaultCalendar
{
    static NSCalendar *calendar;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
#ifdef __IPHONE_8_0
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    
    return calendar;
}

// Bug in iOS
- (void)dealloc
{
    [self->_headerView setDelegate:nil];
    [self->_contentView setDelegate:nil];
}

- (void)setMenuMonthsView:(TUCalendarHeaderView *)menuMonthsView
{
    [self->_headerView setDelegate:nil];
    [self->_headerView setCalendar:nil];
    
    self->_headerView = menuMonthsView;
    [self->_headerView setCalendar:self];
    
    [self.headerView setCurrentDate:self.currentDate];
    
    __weak TUCalendarView *weakSelf = self;
    self.headerView.transferButtonPressed = ^(NSInteger selected){
        if(selected == 0)
        {
            [weakSelf loadPreviousPage];
        }
        else
        {
            [weakSelf loadNextPage];
        }
    };
    [self.headerView reloadLayout];
}

- (void)setContentView:(TUCalendarContentView *)contentView
{
    [self->_contentView setDelegate:nil];
    [self->_contentView setCalendar:nil];
    
    self->_contentView = contentView;
    [self->_contentView setDelegate:self];
    [self->_contentView setCalendar:self];
    
    [self.contentView setCurrentDate:self.currentDate];
    [self.contentView reloadLayout];
}

- (void)reloadData
{
    // Erase cache
    [self.dataCache reloadData];
    
    [self repositionViews];
    [self.contentView reloadData];
}

- (void)reloadLayout
{
    [self.headerView reloadLayout];
    [self.contentView reloadLayout];
    
    if(self.currentDateSelected){
        [self setCurrentDate:self.currentDateSelected];
    }
    else{
        [self setCurrentDate:self.currentDate];
    }
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    NSAssert(currentDate, @"TUCalendarView currentDate cannot be null");
    
    self->_currentDate = currentDate;
    
    [self.headerView setCurrentDate:currentDate];
    [self.contentView setCurrentDate:currentDate];
    
    [self repositionViews];
    [self.contentView reloadData];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == self.contentView){
        self.headerView.scrollEnabled = NO;
    }
    else if(scrollView == self.headerView){
        self.contentView.scrollEnabled = NO;
    }
}

// Use for scroll with scrollRectToVisible or setContentOffset
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updatePage];
}

- (void)updatePage
{
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    CGFloat fractionalPage = self.contentView.contentOffset.x / pageWidth;
    
    int currentPage = roundf(fractionalPage);
    if (currentPage == (NUMBER_PAGES_LOADED / 2)){
        self.contentView.scrollEnabled = YES;
        return;
    }
    
    NSCalendar *calendar = self.defaultCalendar;
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    dayComponent.month = 0;
    dayComponent.day = 0;
    
    dayComponent.month = currentPage - (NUMBER_PAGES_LOADED / 2);
    NSDate *currentDate = [calendar dateByAddingComponents:dayComponent toDate:self.currentDate options:0];
    
    [self setCurrentDate:currentDate];
    
    self.contentView.scrollEnabled = YES;
    
    if(currentPage < (NUMBER_PAGES_LOADED / 2)){
        if([self.dataSource respondsToSelector:@selector(calendarDidLoadPreviousPage)]){
            [self.dataSource calendarDidLoadPreviousPage];
        }
    }
    else if(currentPage > (NUMBER_PAGES_LOADED / 2)){
        if([self.dataSource respondsToSelector:@selector(calendarDidLoadNextPage)]){
            [self.dataSource calendarDidLoadNextPage];
        }
    }
}

- (void)repositionViews
{
    // Position to the middle page
    CGFloat pageWidth = CGRectGetWidth(self.contentView.frame);
    self.contentView.contentOffset = CGPointMake(pageWidth * ((NUMBER_PAGES_LOADED / 2)), self.contentView.contentOffset.y);
    
    CGFloat menuPageWidth = CGRectGetWidth([self.headerView.subviews.firstObject frame]);
    self.headerView.contentOffset = CGPointMake(menuPageWidth * ((NUMBER_PAGES_LOADED / 2)), self.headerView.contentOffset.y);
}

- (void)loadNextPage
{
    self.headerView.scrollEnabled = NO;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) + 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

- (void)loadPreviousPage
{
    self.headerView.scrollEnabled = NO;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = frame.size.width * ((NUMBER_PAGES_LOADED / 2) - 1);
    frame.origin.y = 0;
    [self.contentView scrollRectToVisible:frame animated:YES];
}

@end
