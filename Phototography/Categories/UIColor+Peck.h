//
//  UIColor+Peck.h
//  Peck
//
//  Created by Zakk Hoyt on 4/21/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Peck)
+(UIColor*)randomColor;
+(UIColor*)randomColorWithAlpha:(float)alpha;
+(UIColor*)randomSoftColor;
+(UIColor*)randomSoftColorWithAlpha:(float)alpha;


+(UIColor*)peckPurpleColor;
+(UIColor*)peckRedColor;
+(UIColor*)peckGreenColor;
+(UIColor*)peckBlackColor;
+(UIColor*)peckBlueColor;
+(UIColor*)peckOrangeColor;
+(UIColor*)peckDimBackgroundColor;


+(UIColor*)peckBackgroundColor;
+(UIColor*)peckTranslucentBackgroundColor;
+(UIColor*)peckTintColor;
+(UIColor*)peckAlternateTintColor;
+(UIColor*)peckLightTextColor;
+(UIColor*)peckDarkTextColor;



@end
