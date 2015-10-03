//
//  UIFont+ZH.m
//  ZH
//
//  Created by Zakk Hoyt on 6/8/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "UIFont+ZH.h"

const CGFloat PKFontPointSizeDelta = 0;

@implementation UIFont (ZH)

+(UIFont*)preferredZHFontForTextStyle:(NSString *)style{
    
    if([style isEqualToString:PKFontTextStyleHeadline]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        return [UIFont systemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleBody]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        return [UIFont systemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleSubheadline]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        return [UIFont systemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleFootnote]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        return [UIFont systemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleCaption1]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        return [UIFont systemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleCaption2]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        return [UIFont systemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleHeadlineItalic]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        return [UIFont italicSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleBodyItalic]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        return [UIFont italicSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleSubheadlineItalic]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        return [UIFont italicSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleFootnoteItalic]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        return [UIFont italicSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleCaption1Italic]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        return [UIFont italicSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleCaption2Italic]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        return [UIFont italicSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleHeadlineBold]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        return [UIFont boldSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleBodyBold]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        return [UIFont boldSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleSubheadlineBold]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        return [UIFont boldSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleFootnoteBold]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        return [UIFont boldSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleCaption1Bold]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        return [UIFont boldSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    } else if([style isEqualToString:PKFontTextStyleCaption2Bold]){
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        return [UIFont boldSystemFontOfSize:font.pointSize + PKFontPointSizeDelta];
    }
    
    return nil;
}

@end
