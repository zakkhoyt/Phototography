//
//  ZHDefines.h
//  ZH
//
//  Created by Zakk Hoyt on 06/03/2013.
//
//  This file contains c-macros that alter the behavior of the app in large ways
//  that we would want to toggle on/off at build level. If one of the behaviors turns out to be
//  constantly in one state, we can delete the macro and hard code its effects
//
//  IT IS ESSENTIAL THAT ONE READS THROUGH THIS FILE AND CONFIGURES IT
//  PROPERLY BEFORE A RELEASE!



#ifndef ZH_DEFINES_H
#define ZH_DEFINES_H

//#define ZH_LUMBERJACK 1

#if defined(ZH_LUMBERJACK)
#import <CocoaLumberjack/CocoaLumberjack.h>
#endif

//******************************************************************************
// This is the main configuration section. Comment/Uncomment variables in this section only.
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//******************************************************************************



//******************************************************************************
// Begin server defines:
// Staging server
// end servers: ****************************************************************
//******************************************************************************



//******************************************************************************
// Begin trace defines ***********************************************************
#if defined(ZH_LUMBERJACK)
#   if defined(DEBUG)
#       define ZH_LOG(...) DDLogInfo(@"INFO: %@", [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_INFO(...) DDLogInfo(@"%s:%d ***** INFO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_TODO DDLogDebug(@"%s:%d TODO: Implement", __FUNCTION__, __LINE__);
#       define ZH_LOG_TODO_TASK(...) DDLogDebug(@"%s:%d TODO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_DEBUG(...) DDLogDebug(@"%s:%d ***** DEBUG: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_WARNING(...) DDLogWarn(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_ERROR(...) DDLogError(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_CRITICAL(...) DDLogError(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); NSAssert(NO, @"Critical Error");
#       define ZH_LOG_TRACE DDLogVerbose(@"%s:%d ***** TRACE", __FUNCTION__, __LINE__);
#       define ZH_LOG_TEST(...) DDLogVerbose(@"%s:%d\n********************************************************* TESTING: %@ *********************************************************", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#   else
// We only want warnings and errors to appear in the console for release builds
#       define ZH_LOG(...)
#       define ZH_LOG_INFO(...)
#       define ZH_LOG_TODO
#       define ZH_LOG_TODO_TASK(...)
#       define ZH_LOG_DEBUG(...)
#       define ZH_LOG_WARNING(...) DDLogWarn(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_ERROR(...) DDLogError(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_CRITICAL(...) DDLogError(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_TRACE
#       define ZH_LOG_TEST(...)
#   endif
#else 
#   if defined(DEBUG)
#       define ZH_LOG(...) NSLog(@"INFO: %@", [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_INFO(...) NSLog(@"%s:%d ***** INFO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_TODO NSLog(@"%s:%d TODO: Implement", __FUNCTION__, __LINE__);
#       define ZH_LOG_TODO_TASK(...) NSLog(@"%s:%d TODO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_DEBUG(...) NSLog(@"%s:%d ***** DEBUG: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_WARNING(...) NSLog(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_ERROR(...) NSLog(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_CRITICAL(...) NSLog(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); NSAssert(NO, @"Critical Error");
#       define ZH_LOG_TRACE NSLog(@"%s:%d ***** TRACE", __FUNCTION__, __LINE__);
#       define ZH_LOG_TEST(...) NSLog(@"%s:%d\n********************************************************* TESTING: %@ *********************************************************", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#   else
// We only want warnings and errors to appear in the console for release builds
#       define ZH_LOG(...)
#       define ZH_LOG_INFO(...)
#       define ZH_LOG_TODO
#       define ZH_LOG_TODO_TASK(...)
#       define ZH_LOG_DEBUG(...)
#       define ZH_LOG_WARNING(...) NSLog(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_ERROR(...) NSLog(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_CRITICAL(...) NSLog(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define ZH_LOG_TRACE
#       define ZH_LOG_TEST(...)
#   endif
#endif
// End trace defines ***************************************************************
//******************************************************************************


#endif // ZH_DEFINES_H