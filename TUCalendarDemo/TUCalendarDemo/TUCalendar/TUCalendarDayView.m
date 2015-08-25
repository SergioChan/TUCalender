//
//  TUCalendarDayView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarDayView.h"
#import "TUCalendarCircleView.h"

@interface TUCalendarDayView (){
    UIView *backgroundView;
    TUCalendarCircleView *circleView;
    UILabel *textLabel;
    TUCalendarCircleView *checkedView;
    BOOL isWeekend;
    BOOL isSelected;
    int cacheIsToday;
    NSString *cacheCurrentDateText;
}
@end

static NSString *const kTUCalendarDaySelected = @"kTUCalendarDaySelected";

@implementation TUCalendarDayView

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)commonInit
{
    isSelected = NO;
    self.isOtherMonth = NO;
    
    backgroundView = [UIView new];
    circleView = [TUCalendarCircleView new];
    textLabel = [UILabel new];
    checkedView = [TUCalendarCircleView new];
    checkedView.hidden = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:gesture];
    [self addSubview:backgroundView];
    [self addSubview:checkedView];
    [self addSubview:circleView];
    [self addSubview:textLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDaySelected:) name:kTUCalendarDaySelected object:nil];
}

- (void)layoutSubviews
{
    [self configureConstraintsForSubviews];
    
    // No need to call [super layoutSubviews]
}

// Avoid to calcul constraints (very expensive)
- (void)configureConstraintsForSubviews
{
    textLabel.frame = CGRectMake(0, 0, self.width, self.height);
    backgroundView.frame = CGRectMake(0, 0, self.width, self.height);
    
    
    CGFloat sizeCircle = MIN(self.width, self.height);
    
    sizeCircle = roundf(sizeCircle);
    
    circleView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    circleView.center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
    circleView.layer.cornerRadius = sizeCircle / 2.0f;
    
    checkedView.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    checkedView.center = CGPointMake(self.width / 2.0f, self.height / 2.0f);
    checkedView.layer.cornerRadius = sizeCircle / 2.0f;
}

- (void)setDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendar.defaultCalendar.timeZone;
        [dateFormatter setDateFormat:self.calendar.dayFormat];
    }
    
    self->_date = date;
    
    NSCalendar *calendar = self.calendar.defaultCalendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    if(comps.weekday == 1 || comps.weekday == 7)
    {
        isWeekend = YES;
        
    }
    
    textLabel.text = [dateFormatter stringFromDate:date];
    
    cacheIsToday = -1;
    cacheCurrentDateText = nil;
}

- (void)didTouch
{
    [self setSelected:YES animated:YES];
    [self.calendar setCurrentDateSelected:self.date];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTUCalendarDaySelected object:self.date];
    
    [self.calendar.dataSource calendarDidDateSelected:self.calendar date:self.date];
    
    if(!self.isOtherMonth){
        return;
    }
    
    NSInteger currentMonthIndex = [self monthIndexForDate:self.date];
    NSInteger calendarMonthIndex = [self monthIndexForDate:self.calendar.currentDate];
    
    currentMonthIndex = currentMonthIndex % 12;
    
    if(currentMonthIndex == (calendarMonthIndex + 1) % 12){
        [self.calendar loadNextPage];
    }
    else if(currentMonthIndex == (calendarMonthIndex + 12 - 1) % 12){
        [self.calendar loadPreviousPage];
    }
}

- (void)didDaySelected:(NSNotification *)notification
{
    NSDate *dateSelected = [notification object];
    
    if([self isSameDate:dateSelected]){
        if(!isSelected){
            [self setSelected:YES animated:YES];
        }
    }
    else if(isSelected){
        [self setSelected:NO animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(isSelected == selected){
        animated = NO;
    }
    
    isSelected = selected;
    
    circleView.transform = CGAffineTransformIdentity;
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGFloat opacity = 1.0f;
    
    if(selected){
        circleView.color = GlobalPinkColor;
        textLabel.textColor = GlobalTextSelectedColor;
        checkedView.color = GlobalDefaultColor;
        
        circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1f, 0.1f);
        tr = CGAffineTransformIdentity;
    }
    else if([self isToday]){
        circleView.color = GlobalGrayColor;
        textLabel.textColor = GlobalTextSelectedColor;
    }
    else{
        if(isWeekend)
        {
            textLabel.textColor = GlobalPinkColor;
        }
        else
        {
            textLabel.textColor = GlobalTextColor;
        }
        checkedView.color = GlobalDefaultColor;
        if(!self.isOtherMonth){
            textLabel.alpha = 1.0f;
        }
        else{
            textLabel.alpha = 0.5f;
        }
        
        opacity = 0.0f;
    }
    
    if(animated){
        [UIView animateWithDuration:0.3f animations:^{
            circleView.layer.opacity = opacity;
            circleView.transform = tr;
        }];
    }
    else{
        circleView.layer.opacity = opacity;
        circleView.transform = tr;
    }
}

- (void)setIsOtherMonth:(BOOL)isOtherMonth
{
    self->_isOtherMonth = isOtherMonth;
    [self setSelected:isSelected animated:NO];
}

- (void)reloadData
{
    if([self isToday])
    {
        checkedView.hidden = YES;
    }
    else
    {
        checkedView.hidden = ![self.calendar.dataCache haveCheckedin:self.date];
    }
    
    BOOL selected = [self isSameDate:[self.calendar currentDateSelected]];
    [self setSelected:selected animated:NO];
}

- (BOOL)isToday
{
    if(cacheIsToday == 0){
        return NO;
    }
    else if(cacheIsToday == 1){
        return YES;
    }
    else{
        if([self isSameDate:[NSDate date]]){
            cacheIsToday = 1;
            return YES;
        }
        else{
            cacheIsToday = 0;
            return NO;
        }
    }
}

- (BOOL)isSameDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendar.defaultCalendar.timeZone;
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    }
    
    if(!cacheCurrentDateText){
        cacheCurrentDateText = [dateFormatter stringFromDate:self.date];
    }
    
    NSString *dateText2 = [dateFormatter stringFromDate:date];
    
    if ([cacheCurrentDateText isEqualToString:dateText2]) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)monthIndexForDate:(NSDate *)date
{
    NSCalendar *calendar = self.calendar.defaultCalendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitMonth fromDate:date];
    return comps.month;
}

- (void)reloadLayout
{
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.layer.borderWidth = 0.0f;
    backgroundView.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self configureConstraintsForSubviews];
    [self setSelected:isSelected animated:NO];
}

@end
