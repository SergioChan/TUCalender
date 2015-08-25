//
//  TUCalendarHeaderItemView.m
//  TUCalendarDemo
//
//  Created by chen Yuheng on 15/8/25.
//  Copyright (c) 2015年 chen Yuheng. All rights reserved.
//

#import "TUCalendarHeaderItemView.h"

@interface TUCalendarHeaderItemView(){
    UILabel *monthLabel;
    UILabel *yearLabel;
    UIButton *prevButton;
    UIButton *nextButton;
}

@end

@implementation TUCalendarHeaderItemView

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
    monthLabel = [UILabel new];
    [self addSubview:monthLabel];
    
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.numberOfLines = 1;
    
    yearLabel = [UILabel new];
    [self addSubview:yearLabel];
    
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.numberOfLines = 1;
    
    prevButton = [UIButton new];
    [prevButton addTarget:self action:@selector(prevPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prevButton];
    
    nextButton = [UIButton new];
    [nextButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    NSDateFormatter *tmp= [[NSDateFormatter alloc] init];
    tmp.dateFormat = @"M yyyy";
    NSString *dateStr = [tmp stringFromDate:currentDate];
    NSInteger indexSep = [dateStr rangeOfString:@" "].location;
    
    monthLabel.text = [dateStr substringToIndex:indexSep];
    yearLabel.text = [dateStr substringFromIndex:indexSep];
}

- (void)layoutSubviews
{
    monthLabel.frame = CGRectMake(100.0f, self.height - 39.0f, self.width - 200.0f , 22.0f);
    yearLabel.frame = CGRectMake(100.0f, self.height - 39.0f + 22.0f, self.width - 200.0f, 12.0f);
    prevButton.frame = CGRectMake(30.0f, monthLabel.top + 5.0f, 12.0f, 19.0f);
    nextButton.frame = CGRectMake(self.width - 42.0f,  monthLabel.top + 5.0f, 12.0f, 19.0f);
}

- (void)prevPage:(id)sender
{
    if(self.transferButtonPressed)
    {
        self.transferButtonPressed(0);
    }
}

- (void)nextPage:(id)sender
{
    if(self.transferButtonPressed)
    {
        self.transferButtonPressed(1);
    }
}

- (void)reloadLayout
{
    yearLabel.textColor = GlobalTextColor;
    yearLabel.font = [UIFont systemFontOfSize:12.0f];
    monthLabel.textColor = [UIColor blackColor];
    monthLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    
    [prevButton setBackgroundImage:[UIImage imageNamed:@"backward" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"forward" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
}

@end
