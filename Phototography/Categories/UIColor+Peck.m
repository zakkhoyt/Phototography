//
//  UIColor+Peck.m
//  Peck
//
//  Created by Zakk Hoyt on 4/21/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "UIColor+Peck.h"
#import "ZHDefines.h"

@implementation UIColor (Peck)

+(UIColor*)randomColor{
    return [UIColor randomColorWithAlpha:1.0];
}

+(UIColor*)randomColorWithAlpha:(float)alpha{
    CGFloat red = (arc4random() % 0xFF) / (float)0xFF;
    CGFloat blue = (arc4random() % 0xFF) / (float)0xFF;
    CGFloat green = (arc4random() % 0xFF) / (float)0xFF;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(UIColor*)randomSoftColor{
    return [UIColor randomSoftColorWithAlpha:1.0];
}

+(UIColor*)randomSoftColorWithAlpha:(float)alpha{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); // 0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}


#pragma mark Peck


+(UIColor*)peckPurpleColor{
    return [UIColor colorWithRed:(119/(float)0xFF) green:(76/(float)0xFF) blue:(121/(float)0xFF) alpha:1.0];
}

+(UIColor*)peckYellowColor{
    return [UIColor colorWithRed:(246/(float)0xFF) green:(225/(float)0xFF) blue:(92/(float)0xFF) alpha:1.0];
}

+(UIColor*)peckRedColor{
    return [UIColor colorWithRed:(185/(float)0xFF) green:(73/(float)0xFF) blue:(57/(float)0xFF) alpha:1.0];
}
+(UIColor*)peckGreenColor{
    return [UIColor colorWithRed:(0x8E/(float)0xFF) green:(0xC4/(float)0xFF) blue:(0x64/(float)0xFF) alpha:1.0];
    
}
+(UIColor*)peckBlackColor{
    return [UIColor colorWithRed:(59/(float)0xFF) green:(71/(float)0xFF) blue:(80/(float)0xFF) alpha:1.0];
}

+(UIColor*)peckBlueColor{
    return [UIColor colorWithRed:(02/(float)0xFF) green:(0xBA/(float)0xFF) blue:(0xDB/(float)0xFF) alpha:1.0];
}

+(UIColor*)peckOrangeColor{
    return [UIColor colorWithRed:(0xFF/(float)0xFF) green:(0x9F/(float)0xFF) blue:(0x00/(float)0xFF) alpha:1.0];
}

+(UIColor*)peckDimBackgroundColor{
    return [[UIColor blackColor] colorWithAlphaComponent:0.5];
}








// See PKDefines.h
#if defined(PK_ALTERNATE_COLORS)



+(UIColor*)peckBackgroundColor{
    return [UIColor colorWithRed:(86.3/(float)0xFF) green:(86.3/(float)0xFF) blue:(86.3/(float)0xFF) alpha:1.0];
}
+(UIColor*)peckTranslucentBackgroundColor{
    return [[UIColor peckBackgroundColor] colorWithAlphaComponent:0.9];
}

+(UIColor*)peckTintColor{
    return [UIColor orangeColor];
}
+(UIColor*)peckAlternateTintColor{
    return [UIColor purpleColor];
}
+(UIColor*)peckLightTextColor{
    return [UIColor darkTextColor];
}
+(UIColor*)peckDarkTextColor{
    return [UIColor lightTextColor];
}

#else 
+(UIColor*)peckBackgroundColor{
    return [UIColor colorWithRed:(243/(float)0xFF) green:(242/(float)0xFF) blue:(237/(float)0xFF) alpha:1.0];
}
+(UIColor*)peckTranslucentBackgroundColor{
    return [[UIColor peckBackgroundColor] colorWithAlphaComponent:0.9];
}
+(UIColor*)peckTintColor{
    // Blue
    return [UIColor colorWithRed:(02/(float)0xFF) green:(0xBA/(float)0xFF) blue:(0xDB/(float)0xFF) alpha:1.0];
}
+(UIColor*)peckAlternateTintColor{
    // Orange
//    return [UIColor peckOrangeColor];
    return [UIColor peckGreenColor];
}
+(UIColor*)peckLightTextColor{
    return [UIColor lightTextColor];
}
+(UIColor*)peckDarkTextColor{
    return [UIColor darkTextColor];
}

#endif




@end
