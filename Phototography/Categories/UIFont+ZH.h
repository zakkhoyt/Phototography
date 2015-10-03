//
//  UIFont+ZH.h
//  ZH
//
//  Created by Zakk Hoyt on 6/8/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

// Returns [UIFont preferredZHFontForTextStyle:...] + PKFontPointSizeDelta points
static NSString *PKFontTextStyleHeadline = @"PKFontTextStyleHeadline";
static NSString *PKFontTextStyleBody = @"PKFontTextStyleBody";
static NSString *PKFontTextStyleSubheadline = @"PKFontTextStyleSubheadline";
static NSString *PKFontTextStyleFootnote = @"PKFontTextStyleFootnote";
static NSString *PKFontTextStyleCaption1 = @"PKFontTextStyleCaption1";
static NSString *PKFontTextStyleCaption2 = @"PKFontTextStyleCaption2";

// Returns [UIFont preferredZHFontForTextStyle:...] + PKFontPointSizeDelta points and italic
static NSString *PKFontTextStyleHeadlineItalic = @"PKFontTextStyleHeadlineItalic";
static NSString *PKFontTextStyleBodyItalic = @"PKFontTextStyleBodyItalic";
static NSString *PKFontTextStyleSubheadlineItalic = @"PKFontTextStyleSubheadlineItalic";
static NSString *PKFontTextStyleFootnoteItalic = @"PKFontTextStyleFootnoteItalic";
static NSString *PKFontTextStyleCaption1Italic = @"PKFontTextStyleCaption1Italic";
static NSString *PKFontTextStyleCaption2Italic = @"PKFontTextStyleCaption2Italic";

// Returns [UIFont preferredZHFontForTextStyle:...] + PKFontPointSizeDelta points and bold
static NSString *PKFontTextStyleHeadlineBold = @"PKFontTextStyleHeadlineBold";
static NSString *PKFontTextStyleBodyBold = @"PKFontTextStyleBodyBold";
static NSString *PKFontTextStyleSubheadlineBold = @"PKFontTextStyleSubheadlineBold";
static NSString *PKFontTextStyleFootnoteBold = @"PKFontTextStyleFootnoteBold";
static NSString *PKFontTextStyleCaption1Bold = @"PKFontTextStyleCaption1Bold";
static NSString *PKFontTextStyleCaption2Bold = @"PKFontTextStyleCaption2Bold";

@interface UIFont (ZH)
+(UIFont*)preferredZHFontForTextStyle:(NSString *)style;
@end
