//
//  RSOpacitySlider.m
//  RSColorPicker
//
//  Created by Jared Allen on 5/16/13.
//  Copyright (c) 2013 Red Cactus LLC. All rights reserved.
//

#import "RSOpacitySlider.h"
#import "RSColorFunctions.h"

@interface RSOpacitySlider()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation RSOpacitySlider

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initRoutine];
    }
    return self;
}

- (void)initRoutine {
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.continuous = YES;
    
    self.enabled = YES;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.userInteractionEnabled = NO;
    [self addSubview:self.backgroundView];
    
    UIImage *backgroundImage = RSOpacityBackgroundImage(16.f, [UIScreen mainScreen].scale, [UIColor colorWithWhite:0.5 alpha:1.0]);
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    UIImage *overlayImage = RSOverlayImage(self.bounds.size, [UIScreen mainScreen].scale, [UIColor clearColor], [UIColor whiteColor]);
    [self.backgroundView addSubview:[[UIImageView alloc] initWithImage:overlayImage]];

    [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)myValueChanged:(id)notif {
    self.colorPicker.opacity = self.value;
}

- (void)setColorPicker:(RSColorPickerView *)cp {
    _colorPicker = cp;
    if (!_colorPicker) { return; }
    self.value = self.colorPicker.opacity;
}

- (void)setCornerRadius:(CGFloat)radius {
    self.backgroundView.layer.cornerRadius = radius;
    self.backgroundView.layer.masksToBounds = YES;
}

@end
