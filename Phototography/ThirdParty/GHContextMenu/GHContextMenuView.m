//
//  GHContextOverlayView.m
//  GHContextMenu
//
//  Created by Tapasya on 27/01/14.
//  Copyright (c)2014 Tapasya. All rights reserved.
//

#import "GHContextMenuView.h"
#import "UIColor+ZH.h"

#define GHShowAnimationID @"GHContextMenuViewRriseAnimationID"
#define GHDismissAnimationID @"GHContextMenuViewDismissAnimationID"

NSInteger const GHMainItemSize = 48;
NSInteger const GHMenuItemSize = 44;
NSInteger const GHBorderWidth  = 1;

CGFloat const   GHAnimationDuration = 0.2;
CGFloat const   GHAnimationDelay = GHAnimationDuration/5;


@interface GHMenuItemLocation : NSObject

@property (nonatomic)CGPoint position;
@property (nonatomic)CGFloat angle;

@end

@implementation GHMenuItemLocation

@end


@interface GHContextMenuView ()<UIGestureRecognizerDelegate>
{
    CADisplayLink *displayLink;
}

@property (nonatomic, strong)UILongPressGestureRecognizer* longPressRecognizer;

@property (nonatomic, assign)BOOL isShowing;
@property (nonatomic, assign)BOOL isPaning;

@property (nonatomic)CGPoint longPressLocation;
@property (nonatomic)CGPoint curretnLocation;

@property (nonatomic, strong)NSMutableArray* menuItems;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIView *labelView;
@property (nonatomic, strong)NSMutableArray* menuTitles;

@property (nonatomic)CGFloat radius;
@property (nonatomic)CGFloat arcAngle;
@property (nonatomic)CGFloat angleBetweenItems;
@property (nonatomic, strong)NSMutableArray* itemLocations;
@property (nonatomic)NSInteger prevIndex;

@property (nonatomic)CGColorRef itemBGHighlightedColor;
@property (nonatomic)CGColorRef itemBGColor;

@end

@implementation GHContextMenuView

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self){
        // Initialization code
        self.userInteractionEnabled = YES;
        self.backgroundColor  = [UIColor clearColor];

        // Default the menuActionType to Pan (original/default)
        _menuActionType = GHContextMenuActionTypePan;

        displayLink = [CADisplayLink displayLinkWithTarget:self
                                                  selector:@selector(highlightMenuItemForPoint)];
        
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        _menuItems = [NSMutableArray new];
        _menuTitles = [NSMutableArray new];
        _itemLocations = [NSMutableArray new];
        _arcAngle = M_PI_2;
        _radius = 90;
        
        self.itemBGColor = [UIColor zhBlackColor].CGColor;
        self.itemBGHighlightedColor = [UIColor zhTintColor].CGColor;
        
    }
    return self;
}

#pragma mark Layer Touch Tracking
-(NSInteger)indexOfClosestMatchAtPoint:(CGPoint)point {
    int i = 0;
    for( CALayer *menuItemLayer in self.menuItems ){
        if( CGRectContainsPoint( menuItemLayer.frame, point )){
            NSLog( @"Touched Layer at index: %i", i);
            return i;
        }
        i++;
    }
    return -1;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint menuAtPoint = CGPointZero;

    if ([touches count] == 1){

        UITouch *touch = (UITouch *)[touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];

        NSInteger menuItemIndex = [self indexOfClosestMatchAtPoint:touchPoint];
        if( menuItemIndex > -1 ){
            menuAtPoint = [(CALayer *)self.menuItems[(NSUInteger)menuItemIndex] position];
        }

        if( (self.prevIndex >= 0 && self.prevIndex != menuItemIndex)){
            [self resetPreviousSelection];
        }
        self.prevIndex = menuItemIndex;
    }

    [self dismissWithSelectedIndexForMenuAtPoint: menuAtPoint];
}

#pragma mark LongPress handler

// Split this out of the longPressDetected so that we can reuse it with touchesBegan (above)
-(void)dismissWithSelectedIndexForMenuAtPoint:(CGPoint)point {

    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndex: forMenuAtPoint:)] && self.prevIndex >= 0){
        [self.delegate didSelectItemAtIndex:self.prevIndex forMenuAtPoint:point];
        self.prevIndex = -1;
    }

    [self hideMenu];
}

- (void)longPressDetected:(UIGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        self.prevIndex = -1;
        
        CGPoint pointInView = [gestureRecognizer locationInView:gestureRecognizer.view];
        if (self.dataSource != nil && [self.dataSource respondsToSelector:@selector(shouldShowMenuAtPoint:)] && ![self.dataSource shouldShowMenuAtPoint:pointInView]){
            return;
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.longPressLocation = [gestureRecognizer locationInView:self];
        
//        self.frame = [[UIScreen mainScreen] applicationFrame];
        self.layer.backgroundColor = [UIColor zhDimBackgroundColor].CGColor;
        self.isShowing = YES;
        [self animateMenu:YES];
        [self setNeedsDisplay];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        if (self.isShowing && self.menuActionType == GHContextMenuActionTypePan){
            self.isPaning = YES;
            self.curretnLocation =  [gestureRecognizer locationInView:self];
        }
    }
    
    // Only trigger if we're using the GHContextMenuActionTypePan (default)
    if( gestureRecognizer.state == UIGestureRecognizerStateEnded && self.menuActionType == GHContextMenuActionTypePan ){
        CGPoint menuAtPoint = [self convertPoint:self.longPressLocation toView:gestureRecognizer.view];
        [self dismissWithSelectedIndexForMenuAtPoint:menuAtPoint];
    }
}

- (void)showMenu {
    
}

- (void)hideMenu {
    if (self.isShowing){
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.isShowing = NO;
        self.isPaning = NO;
        [self animateMenu:NO];
        [self setNeedsDisplay];
        [self removeFromSuperview];
    }
    
}

- (CALayer*)layerWithImage:(UIImage*)image {
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, GHMenuItemSize, GHMenuItemSize);
    layer.cornerRadius = GHMenuItemSize/2;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = GHBorderWidth;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0, -1);
    layer.backgroundColor = self.itemBGColor;
    
    CALayer* imageLayer = [CALayer layer];
    imageLayer.contents = (id)image.CGImage;
    imageLayer.bounds = CGRectMake(0, 0, GHMenuItemSize*0.8, GHMenuItemSize*0.8);
    imageLayer.position = CGPointMake(GHMenuItemSize/2, GHMenuItemSize/2);
    [layer addSublayer:imageLayer];
    
    return layer;
}

- (void)setDataSource:(id<GHContextOverlayViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];

}

# pragma mark Menu item layout
- (void)reloadData{
    [self.menuItems removeAllObjects];
    [self.itemLocations removeAllObjects];
    [self.menuTitles removeAllObjects];
    
    if (self.dataSource != nil){
        NSInteger count = [self.dataSource numberOfMenuItems];
        for (int i = 0; i < count; i++){
            UIImage* image = [self.dataSource imageForItemAtIndex:i];
            CALayer *layer = [self layerWithImage:image];
            [self.layer addSublayer:layer];
            [self.menuItems addObject:layer];
            
            if([self.dataSource respondsToSelector:@selector(titleForItemAtIndex:)]){
                NSString *title = [self.dataSource titleForItemAtIndex:i];
                [self.menuTitles addObject:title];
            }
        }
    }
}

- (void)layoutMenuItems {
    [self.itemLocations removeAllObjects];
    
    CGSize itemSize = CGSizeMake(GHMenuItemSize, GHMenuItemSize);
    CGFloat itemRadius = sqrt(pow(itemSize.width, 2)+ pow(itemSize.height, 2))/ 2;
    self.arcAngle = ((itemRadius * self.menuItems.count)/ self.radius)* 1.5;
    
    NSUInteger count = self.menuItems.count;
	BOOL isFullCircle = (self.arcAngle == M_PI*2);
	NSUInteger divisor = (isFullCircle)? count : count - 1;

    self.angleBetweenItems = self.arcAngle/divisor;
    
    // Get min/max position.x
    CGFloat minX = self.bounds.size.width;
    CGFloat maxX = 0;
    CGFloat minY = self.bounds.size.height;
    CGFloat maxY = 0;
    // Get min position.y - some
    for (int i = 0; i < self.menuItems.count; i++){
        GHMenuItemLocation *location = [self locationForItemAtIndex:i];
        [self.itemLocations addObject:location];
    
        minX = MIN(minX, location.position.x);
        maxX = MAX(maxX, location.position.x);
        minY = MIN(minY, location.position.y);
        maxY = MAX(maxY, location.position.y);
        
        CALayer* layer = (CALayer*)[self.menuItems objectAtIndex:i];
        layer.transform = CATransform3DIdentity;
       
        // Rotate menu items based on orientation
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
            CGFloat angle = [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ? M_PI_2 : -M_PI_2;
            layer.transform = CATransform3DRotate(CATransform3DIdentity, angle, 0, 0, 1);
        }
    }
    
    if(self.menuTitles.count){
        if(self.labelView){
            [self.labelView removeFromSuperview];
            self.labelView = nil;
            [self.label removeFromSuperview];
            self.label = nil;
        }
        CGFloat labelWidth = MAX(maxX - minX, maxY - minY);
        CGRect labelFrame = CGRectMake(minX, minY - 2*GHMainItemSize, labelWidth, GHMenuItemSize);
        self.labelView = [[UIView alloc]initWithFrame:labelFrame];
        self.labelView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.labelView];
    }
}

- (GHMenuItemLocation*)locationForItemAtIndex:(NSUInteger)index {
	CGFloat itemAngle = [self itemAngleAtIndex:index];
	
	CGPoint itemCenter = CGPointMake(self.longPressLocation.x + cosf(itemAngle)* self.radius,
									 self.longPressLocation.y + sinf(itemAngle)* self.radius);
    GHMenuItemLocation *location = [GHMenuItemLocation new];
    location.position = itemCenter;
    location.angle = itemAngle;
    
    return location;
}

- (CGFloat)itemAngleAtIndex:(NSUInteger)index {
    float bearingRadians = [self angleBeweenStartinPoint:self.longPressLocation endingPoint:self.center];
    
    CGFloat angle =  bearingRadians - self.arcAngle/2;
    
	CGFloat itemAngle = angle + (index * self.angleBetweenItems);
    
    if (itemAngle > 2 *M_PI){
        itemAngle -= 2*M_PI;
    } else if (itemAngle < 0){
        itemAngle += 2*M_PI;
    }

    return itemAngle;
}

# pragma mark - helper methiods

- (CGFloat)calculateRadius {
    CGSize mainSize = CGSizeMake(GHMainItemSize, GHMainItemSize);
    CGSize itemSize = CGSizeMake(GHMenuItemSize, GHMenuItemSize);
    CGFloat mainRadius = sqrt(pow(mainSize.width, 2)+ pow(mainSize.height, 2))/ 2;
    CGFloat itemRadius = sqrt(pow(itemSize.width, 2)+ pow(itemSize.height, 2))/ 2;
    
    CGFloat minRadius = (CGFloat)(mainRadius + itemRadius);
    CGFloat maxRadius = ((itemRadius * self.menuItems.count)/ self.arcAngle)* 1.5;
    
	CGFloat radius = MAX(minRadius, maxRadius);

    return radius;
}

- (CGFloat)angleBeweenStartinPoint:(CGPoint)startingPoint endingPoint:(CGPoint)endingPoint {
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y);
    float bearingRadians = atan2f(originPoint.y, originPoint.x);
    
    bearingRadians = (bearingRadians > 0.0 ? bearingRadians : (M_PI*2 + bearingRadians));

    return bearingRadians;
}

- (CGFloat)validaAngle:(CGFloat)angle {
    if (angle > 2*M_PI){
        angle = [self validaAngle:angle - 2*M_PI];
    }
    
    return angle;
}

# pragma mark Animation and selection
-(void)highlightMenuItemForPoint {
    if (self.isShowing && self.isPaning){
        
        CGFloat angle = [self angleBeweenStartinPoint:self.longPressLocation endingPoint:self.curretnLocation];
        NSInteger closeToIndex = -1;
        for (int i = 0; i < self.menuItems.count; i++){
            GHMenuItemLocation* itemLocation = [self.itemLocations objectAtIndex:i];
            if (fabs(itemLocation.angle - angle)< self.angleBetweenItems/2){
                closeToIndex = i;
                break;
            }
        }
        
        if (closeToIndex >= 0 && closeToIndex < self.menuItems.count){
            
            CGFloat distanceFromCenter = sqrt(pow(self.curretnLocation.x - self.longPressLocation.x, 2)+ pow(self.curretnLocation.y-self.longPressLocation.y, 2));
            CGFloat toleranceDistance = (self.radius - GHMainItemSize/(2*sqrt(2))- GHMenuItemSize/(2*sqrt(2)))/2;
            CGFloat distanceFromItem = fabs(distanceFromCenter - self.radius)- GHMenuItemSize/(2*sqrt(2));
            if (fabs(distanceFromItem) < toleranceDistance) {
                if(self.menuTitles.count){
                    if(self.label == nil){
                        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.labelView.frame.size.width, self.labelView.frame.size.height)];
                        self.label.backgroundColor = [UIColor zhBackgroundColor];
                        self.label.textAlignment = NSTextAlignmentCenter;
                        self.label.textColor = [UIColor zhDarkTextColor];
                        [self.labelView addSubview:self.label];
                    }
                    self.label.text = self.menuTitles[closeToIndex];
                }
                    
                CALayer *layer = [self.menuItems objectAtIndex:closeToIndex];
                layer.backgroundColor = [UIColor zhTintColor].CGColor;

                CGFloat distanceFromItemBorder = fabs(distanceFromItem);
                CGFloat scaleFactor = 1 + 0.5 *(1-distanceFromItemBorder/toleranceDistance);
                if (scaleFactor < 1.0){
                    scaleFactor = 1.0;
                }
                
                // Scale
                GHMenuItemLocation* itemLocation = [self.itemLocations objectAtIndex:closeToIndex];
                CATransform3D scaleTransForm =  CATransform3DScale(CATransform3DIdentity, scaleFactor, scaleFactor, 1.0);
                CGFloat xtrans = cosf(itemLocation.angle);
                CGFloat ytrans = sinf(itemLocation.angle);
                CATransform3D transLate = CATransform3DTranslate(scaleTransForm, 10*scaleFactor*xtrans, 10*scaleFactor*ytrans, 0);
                layer.transform = transLate;
                
                if (self.prevIndex >= 0 && self.prevIndex != closeToIndex){
                    [self resetPreviousSelection];
                }
                
                self.prevIndex = closeToIndex;
            
            } else if(self.prevIndex >= 0){
                [self resetPreviousSelection];
            }
        } else {
            [self resetPreviousSelection];
        }
    }
}

- (void)resetPreviousSelection {
    if (self.prevIndex >= 0){
        CALayer *layer = self.menuItems[self.prevIndex];
        GHMenuItemLocation* itemLocation = [self.itemLocations objectAtIndex:self.prevIndex];
        layer.position = itemLocation.position;
        layer.backgroundColor = self.itemBGColor;
        layer.transform = CATransform3DIdentity;
        self.prevIndex = -1;
    }

    [self.label removeFromSuperview];
    self.label = nil;
}

- (void)animateMenu:(BOOL)isShowing {
    if (isShowing){
        [self layoutMenuItems];
    }
    
    for (NSUInteger index = 0; index < self.menuItems.count; index++){
        CALayer *layer = self.menuItems[index];
        layer.opacity = 0;
        CGPoint fromPosition = self.longPressLocation;
        
        GHMenuItemLocation* location = [self.itemLocations objectAtIndex:index];
        CGPoint toPosition = location.position;
        
        double delayInSeconds = index * GHAnimationDelay;
        
        CABasicAnimation *positionAnimation;
        positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:isShowing ? fromPosition : toPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:isShowing ? toPosition : fromPosition];
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.45f :1.2f :0.75f :1.0f];
        positionAnimation.duration = GHAnimationDuration;
        positionAnimation.beginTime = [layer convertTime:CACurrentMediaTime()fromLayer:nil] + delayInSeconds;
        [positionAnimation setValue:[NSNumber numberWithUnsignedInteger:index] forKey:isShowing ? GHShowAnimationID : GHDismissAnimationID];
        positionAnimation.delegate = self;
        [layer addAnimation:positionAnimation forKey:@"riseAnimation"];
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    if([anim valueForKey:GHShowAnimationID]){
        NSUInteger index = [[anim valueForKey:GHShowAnimationID] unsignedIntegerValue];
        CALayer *layer = self.menuItems[index];
        
        GHMenuItemLocation* location = [self.itemLocations objectAtIndex:index];
        CGFloat toAlpha = 1.0;
        
        layer.position = location.position;
        layer.opacity = toAlpha;
    }
    else if([anim valueForKey:GHDismissAnimationID]){
        NSUInteger index = [[anim valueForKey:GHDismissAnimationID] unsignedIntegerValue];
        CALayer *layer = self.menuItems[index];
        CGPoint toPosition = self.longPressLocation;
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        layer.position = toPosition;
        layer.backgroundColor = self.itemBGColor;
        layer.opacity = 0.0f;
        layer.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
}

- (void)drawCircle:(CGPoint)locationOfTouch {
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx,GHBorderWidth/2);
    CGContextSetRGBStrokeColor(ctx,0.8,0.8,0.8,1.0);
    CGContextAddArc(ctx,locationOfTouch.x,locationOfTouch.y,GHMainItemSize/2,0.0,M_PI*2,YES);
    CGContextStrokePath(ctx);
}

- (void)drawRect:(CGRect)rect {
    if (self.isShowing){
        [self drawCircle:self.longPressLocation];
    }
}
@end
