//
//  SVSegmentedControl.h
//  SVSegmentedControl_Example
//
//  Created by Saumitra Vaidya on 3/6/13.
//  Copyright (c) 2013 Saumitra Vaidya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SVSegmentedControlDelegate <NSObject>

@end

typedef enum {
    SVSegmentedControlModeSticky = 0,
    SVSegmentedControlModeButton,
    SVSegmentedControlModeMultipleSelection
}SVSegmentedControlMode;

typedef enum {
    SVSegmentedControlSelectionAnimationDefault = 0,
    SVSegmentedControlSelectionAnimationFade,
    SVSegmentedControlSelectionAnimationSlide
}SVSegmentedControlSelectionAnimation;

typedef enum {
    SVSegmentedControlArrowDirectionUp = 0,
    SVSegmentedControlArrowDirectionDown,
}SVSegmentedControlArrowDirection;

@interface SVSegmentedControl : UIControl

@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIView *selectionView;

@property (nonatomic, retain) UIImage *selectedBackgroundImage;
@property (nonatomic, retain) UIImage *separatorImage;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) SVSegmentedControlMode segmentedControlMode;
@property (nonatomic, assign) SVSegmentedControlSelectionAnimation segmentedControlSelectionAnimation;

- (id)initWithTitles:(NSArray*)titles;
- (void)setSelectedIndex:(NSUInteger)index;
- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage;
- (void)setTitleTextColor:(UIColor*)titleTextColor;
- (void)setTitleTextFont:(NSString*)font ofSize:(CGFloat)size ;

@end
