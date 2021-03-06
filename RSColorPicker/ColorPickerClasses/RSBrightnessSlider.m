//
//  RSBrightnessSlider.m
//  RSColorPicker
//
//  Created by Ryan Sullivan on 8/12/11.
//

#import "RSBrightnessSlider.h"

#import "RSColorFunctions.h"

#import "CGContextCreator.h"

/**
 * Retubrns Image with hourglass looking slider that looks something like:
 *
 *  6 ______ 5
 *    \    /
 *   7 \  / 4
 *    ->||<--- cWidth (Center Width)
 *      ||
 *   8 /  \ 3
 *    /    \
 *  1 ------ 2
 */
UIImage * RSHourGlassThumbImage(CGSize size, CGFloat cWidth){

    //Set Size
    CGFloat width = size.width;
    CGFloat height = size.height;

    //Setup Context
    CGContextRef ctx = [CGContextCreator newARGBBitmapContextWithSize:size];

    //Set Colors
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);

    //Draw Slider, See Diagram above for point numbers
    CGFloat yDist83 = sqrtf(3)/2*width;
    CGFloat yDist74 = height - yDist83;
    CGPoint addLines[] = {
        CGPointMake(0, -1),                          //Point 1
        CGPointMake(width, -1),                      //Point 2
        CGPointMake(width/2+cWidth/2, yDist83),      //Point 3
        CGPointMake(width/2+cWidth/2, yDist74),      //Point 4
        CGPointMake(width, height+1),                //Point 5
        CGPointMake(0, height+1),                    //Point 6
        CGPointMake(width/2-cWidth/2, yDist74),      //Point 7
        CGPointMake(width/2-cWidth/2, yDist83)       //Point 8
    };
    //Fill Path
    CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextFillPath(ctx);

    //Stroke Path
    CGContextAddLines(ctx, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return image;
}

/**
 * Returns image that looks like a square arrow loop, something like:
 *
 * +-----+
 * | +-+ | ------------------------
 * | | | |                       |
 * ->| |<--- loopSize.width     loopSize.height
 * | | | |                       |
 * | +-+ | ------------------------
 * +-----+
 */
UIImage * RSArrowLoopThumbImage(CGSize size, CGSize loopSize){

    //Setup Rects
    CGRect outsideRect = CGRectMake(0, 0, size.width, size.height);
    CGRect insideRect;
    insideRect.size = loopSize;
    insideRect.origin.x = (size.width - loopSize.width)/2;
    insideRect.origin.y = (size.height - loopSize.height)/2;

    //Setup Context
    CGContextRef ctx = [CGContextCreator newARGBBitmapContextWithSize:size];

    //Set Colors
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);

    CGMutablePathRef loopPath = CGPathCreateMutable();
    CGPathAddRect(loopPath, nil, outsideRect);
    CGPathAddRect(loopPath, nil, insideRect);


    //Fill Path
    CGContextAddPath(ctx, loopPath);
    CGContextEOFillPath(ctx);

    //Stroke Path
    CGContextAddRect(ctx, insideRect);
    CGContextStrokePath(ctx);

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);

    //Memory
    CGPathRelease(loopPath);
    CGContextRelease(ctx);

    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);

    return image;
}

@interface RSBrightnessSlider()

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation RSBrightnessSlider

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
    
    UIImage *overlayImage = RSOverlayImage(self.bounds.size, [UIScreen mainScreen].scale, [UIColor blackColor], [UIColor whiteColor]);
    [self.backgroundView addSubview:[[UIImageView alloc] initWithImage:overlayImage]];
    
    [self addTarget:self action:@selector(myValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)myValueChanged:(id)notif {
    [self.colorPicker setBrightness:self.value];
}

- (void)setColorPicker:(RSColorPickerView*)cp {
    _colorPicker = cp;
    if (!_colorPicker) { return; }
    self.value = self.colorPicker.brightness;
}

- (void)setCornerRadius:(CGFloat)radius {
    self.backgroundView.layer.cornerRadius = radius;
    self.backgroundView.layer.masksToBounds = YES;
}

@end
