//
//  ZHAssetAnnotationView.m
//  Peck
//
//  Created by Zakk Hoyt on 10/4/15.
//  Copyright © 2015 Zakk Hoyt. All rights reserved.
//

#import "ZHAssetAnnotationView.h"
#import "UIColor+ZH.h"
#import "ZHDefines.h"

@interface ZHAssetAnnotationView ()
@property (strong, nonatomic) UILabel *countLabel;
@end

@implementation ZHAssetAnnotationView


- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
        [self setCount:0];
        self.layer.zPosition = 0;
    }
    return self;
}

-(void)dealloc{
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    
//    UIColor *outerCircleStrokeColor = [UIColor zhAlternateTintColor];
//    UIColor *innerCircleFillColor = [UIColor zhAlternateTintColor];
//    outerCircleStrokeColor = outerCircleStrokeColor;
//    UIColor *innerCircleStrokeColor = [UIColor zhBackgroundColor];
//    
//    CGRect circleFrame = CGRectInset(rect, 4, 4);
//    
//    [outerCircleStrokeColor setStroke];
//    CGContextSetLineWidth(context, 5.0);
//    CGContextStrokeEllipseInRect(context, circleFrame);
//    
//    [innerCircleStrokeColor setStroke];
//    CGContextSetLineWidth(context, 4);
//    CGContextStrokeEllipseInRect(context, circleFrame);
//    
//    [innerCircleFillColor setFill];
//    CGContextFillEllipseInRect(context, circleFrame);
    UIImage *image = [UIImage imageNamed:@"target"];
    [image drawInRect:self.bounds];
    
    
    
}


- (void)setupLabel{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor zhBackgroundColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    //    _countLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    //    _countLabel.shadowOffset = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count{
    _count = count;
    
#if defined(ZH_HIDE_ANNOTATION_COUNT)
    self.countLabel.hidden = YES;
#else
    self.countLabel.hidden = self.count == 0;
#endif
    
    
    CGRect newBounds = CGRectMake(0, 0, roundf(44 * [self scaledValueForValue:count]), roundf(44 * [self scaledValueForValue:count]));
    self.frame = [self centerRect:newBounds onPoint:self.center];
    
    //    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width, newBounds.size.height);
    self.countLabel.frame = [self centerRect:newLabelBounds onPoint:[self centerOfRect:newBounds]];
    self.countLabel.text = [@(_count) stringValue];
    
    
#if defined(ZH_FAKE_PING_RIPPLES)
    if(self.annotationColor == [UIColor zhAlternateTintColor]){
        // ripple stuff
        NSMutableArray *pings = [@[]mutableCopy];
        for(NSUInteger index = 0; index <= 10; index++){
            NSUInteger random = arc4random() % 10;
            random++;
            ZHPing *ping = [[ZHPing alloc]init];
            ping.type = random;
            [pings addObject:ping];
        }
        
        if(self.rippleView){
            [self.rippleView stopAnimating];
            [self.rippleView removeFromSuperview];
            _rippleView = nil;
        }
        self.rippleView = [[ZHRippleView alloc]initWithFrame:self.bounds];
        self.rippleView.pings = pings;
        [self.rippleView.layer removeFromSuperlayer];
        [self.layer insertSublayer:self.rippleView.layer below:self.layer];
        [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"sublayer of type %@ at index: %lu", NSStringFromClass([obj class]), (unsigned long)idx);
        }];
        [self.rippleView startAnimating];
    }
#endif
    [self setNeedsDisplay];
}


-(CGPoint)centerOfRect:(CGRect)rect{
    
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

-(CGRect)centerRect:(CGRect)rect onPoint:(CGPoint)point{
    CGRect r = CGRectMake(point.x - rect.size.width/2.0,
                          point.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}

static CGFloat const VWWScaleFactorAlpha = 0.3;
static CGFloat const VWWScaleFactorBeta = 0.4;

-(CGFloat)scaledValueForValue:(CGFloat)value{
    return 1.0 / (1.0 + expf(-1 * VWWScaleFactorAlpha * powf(value, VWWScaleFactorBeta)));
}


@end
