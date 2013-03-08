//
//  SVSegmentedControl.m
//  SVSegmentedControl_Example
//
//  Created by Saumitra Vaidya on 3/6/13.
//  Copyright (c) 2013 Saumitra Vaidya. All rights reserved.
//

#import "SVSegmentedControl.h"

@interface SVSegmentedControl ()

@property (nonatomic, retain) NSMutableArray *buttonsArray;
@property (nonatomic, retain) UIColor *titleTextColor;
@property (nonatomic, retain) UIFont *titleTextFont;

- (void)updateButtons;
- (void)updateSelectionView;

@end

@implementation SVSegmentedControl

@synthesize titleArray = _titleArray;
@synthesize buttonsArray = _buttonsArray;
@synthesize containerView = _containerView;
@synthesize selectionView = _selectionView;

@synthesize selectedBackgroundImage = _selectedBackgroundImage;
@synthesize separatorImage = _separatorImage;

@synthesize segmentedControlMode = _segmentedControlMode;
@synthesize segmentedControlSelectionAnimation = _segmentedControlSelectionAnimation;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.titleArray = [[NSArray alloc] initWithArray:titles];
        self.buttonsArray = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
    
        self.containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_containerView];
        
        self.selectionView = [[UIView alloc] init];
        _selectionView.backgroundColor = [UIColor redColor];
        _selectionView.hidden = NO;
        [self.containerView addSubview:_selectionView];
        
        self.segmentedControlSelectionAnimation = SVSegmentedControlSelectionAnimationDefault;
        self.segmentedControlMode = SVSegmentedControlSelectionAnimationDefault;
        
        [self updateButtons];
    }
    return self;
}

#define HEIGHTOFPOPUPTRIANGLE 20
#define WIDTHOFPOPUPTRIANGLE 40

- (void)layoutSubviews {
    [self sizeToFit];
    CGRect viewBoundRect = self.bounds;

//    Container View
    CGRect rect = CGRectMake(viewBoundRect.origin.x+10, viewBoundRect.origin.y+10, viewBoundRect.size.width-20, viewBoundRect.size.height-20);
    _containerView.frame = rect;
    [_containerView sizeToFit];
    
    [self layoutButtons];
    
//    SelectionView
    UIButton *firstButton = [_buttonsArray objectAtIndex:0];
    CGRect buttonFrame = firstButton.frame;
    rect = buttonFrame;
    _selectionView.frame = rect;
}

- (void)layoutButtons {
    CGRect containerRect = _containerView.bounds;
    CGFloat selectionViewWidth = roundf(containerRect.size.width/[_buttonsArray count]);
    
    CGRect rect = CGRectMake(containerRect.origin.x, containerRect.origin.y, containerRect.size.width/[_buttonsArray count], containerRect.size.height-1);
    for (UIButton *button in _buttonsArray) {
        button.frame = rect;
        rect.origin.x = rect.origin.x + selectionViewWidth;
        rect.origin.y = rect.origin.y;
    }
}

- (void)setSelectedIndex:(NSUInteger)index {
    _selectedIndex = index;
    [self updateSelectionView];
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    self.selectedBackgroundImage = selectedBackgroundImage;
}

- (void)setTitleTextColor:(UIColor*)titleTextColor {
    if (!titleTextColor) {
        _titleTextColor = titleTextColor;
        return;
    }
    
    _titleTextColor = titleTextColor;
    [self updateButtons];
}

- (void)setTitleTextFont:(NSString*)font ofSize:(CGFloat)size {
    if (!font) {
        _titleTextFont = [UIFont systemFontOfSize:14];
        return;
    }
    
    _titleTextFont = [UIFont fontWithName:font size:size];
    [self updateButtons];
}

#pragma mark - Internal Methods
- (void)updateButtons {
    [_buttonsArray makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_buttonsArray removeAllObjects];
    [_titleArray enumerateObjectsWithOptions:NSEnumerationConcurrent
                                usingBlock:^(id obj, NSUInteger index, BOOL *stop){
                                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                    NSString *title = (NSString*)obj;
                                    [button setTitle:title forState:UIControlStateNormal];
                                    [button setTitle:title forState:UIControlStateSelected];
                                    [button setTitleColor:_titleTextColor forState:UIControlStateNormal];
                                    [button setTitleColor:_titleTextColor forState:UIControlStateSelected];
                                    button.titleLabel.font = _titleTextFont;
                                    button.titleEdgeInsets = UIEdgeInsetsZero;
                                    button.titleLabel.minimumScaleFactor = 0.5;
                                    button.backgroundColor = [UIColor clearColor];
                                    button.enabled = YES;
                                    button.tag = index;
                                    
                                    [button addTarget:self
                                               action:@selector(segmentButtonPressed:)
                                     forControlEvents:UIControlEventTouchDown];
                                    [_buttonsArray addObject:button];
                                    [self.containerView addSubview:button];
                                   }];
}

- (void)updateSelectionView {
    if ([_buttonsArray count] == 0) {
        return;
    }
    
    UIButton *button = (UIButton*)[_buttonsArray objectAtIndex:_selectedIndex];
    if (_segmentedControlSelectionAnimation == SVSegmentedControlSelectionAnimationDefault) {
        [self animateSelectionViewToButton:button];
    }
    
    else if (_segmentedControlSelectionAnimation == SVSegmentedControlSelectionAnimationSlide) {
        [self slideSelectionViewToButton:button];
    }
}

#pragma mark - SelectionView animations
- (void)animateSelectionViewToButton:(UIButton*)button {
    [UIView animateWithDuration:0.2
                     animations:^{
                         _selectionView.hidden = YES;
                         
                         CGRect selectionViewFrame = _selectionView.frame;
                         CGRect buttonFrame = button.frame;
                         
                         selectionViewFrame = buttonFrame;
                         
                         _selectionView.frame = selectionViewFrame;
                     }
                     completion:^(BOOL finished){
                         _selectionView.hidden = NO;
                     }];
}

- (void)slideSelectionViewToButton:(UIButton*)button {
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect selectionViewFrame = _selectionView.frame;
                         CGRect buttonFrame = button.frame;
                         
                         selectionViewFrame = buttonFrame;
                         
                         _selectionView.frame = selectionViewFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

#pragma mark - Button Action 
- (void)segmentButtonPressed:(id)sender {
    UIButton *button = (UIButton*)sender;
    
    NSUInteger selectedIndex = button.tag;
    
    if (_segmentedControlMode == SVSegmentedControlModeMultipleSelection) {
        
    }
    else {
        [self setSelectedIndex:selectedIndex];
    }
    
    BOOL willSendAction = (selectedIndex == _selectedIndex);
    
    if (willSendAction) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
