//
//  PKDefines.h
//  Peck
//
//  Created by Zakk Hoyt on 06/03/2013.
//
//  This file contains c-macros that alter the behavior of the app in large ways
//  that we would want to toggle on/off at build level. If one of the behaviors turns out to be
//  constantly in one state, we can delete the macro and hard code its effects
//
//  IT IS ESSENTIAL THAT ONE READS THROUGH THIS FILE AND CONFIGURES IT
//  PROPERLY BEFORE A RELEASE!



#ifndef PECK_DEFINES_H
#define PECK_DEFINES_H

//#define PK_LUMBERJACK 1

#if defined(PK_LUMBERJACK)
#import <CocoaLumberjack/CocoaLumberjack.h>
#endif

//******************************************************************************
// This is the main configuration section. Comment/Uncomment variables in this section only.

////**  Use SF Giants color scheme instead of peck color scheme
//#define PK_ALTERNATE_COLORS 1

//** Make the clustered annotations pulsate with random ripples even though they are not unviewed
//#define PK_FAKE_PING_RIPPLES 1

// Add a badge to the appropriate tab bar item on incoming PubNub event
#define PK_TAB_BADGE_ON_PECK 1

#define PK_HIDE_ANNOTATION_COUNT 1


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// end servers: ****************************************************************
//******************************************************************************



//******************************************************************************
// Begin server defines:
// Staging server
#define PK_SERVER_STAGING                   @"http://peck.me:8080"    // Sends push notifications to production server
#define PK_SERVER_API_STAGING               @"/api/v5"
#define PK_PUB_NUB_PUB_KEY_STAGING          @"pub-c-5f52ba40-c142-44da-8a85-911582b03199"
#define PK_PUB_NUB_SUB_KEY_STAGING          @"sub-c-4c37031e-ef5d-11e4-a4a1-02ee2ddab7fe"
#define PK_MIXPANEL_KEY_STAGING             @""

// QA server
#define PK_SERVER_QA                        @"http://qa.peck.me:8080"    // Sends notifications to development(sandbox) server
#define PK_SERVER_API_QA                    @"/api/v5"
#define PK_PUB_NUB_PUB_KEY_QA               @"pub-c-ca70b892-f157-417c-bf3e-084fdec4293f"
#define PK_PUB_NUB_SUB_KEY_QA               @"sub-c-5c7a7ddc-ef5d-11e4-bad8-02ee2ddab7fe"
#define PK_MIXPANEL_KEY_QA                  @""

//#define PK_USE_STAGING_FOR_RELEASE_BUILDS 1
#if defined(PK_USE_STAGING_FOR_RELEASE_BUILDS)
#   define PK_PECK_SERVER PK_SERVER_STAGING
#   define PK_PECK_SERVER_API PK_SERVER_API_STAGING
#   define PK_PUB_NUB_PUB_KEY PK_PUB_NUB_PUB_KEY_STAGING
#   define PK_PUB_NUB_SUB_KEY PK_PUB_NUB_SUB_KEY_STAGING
#   define PK_MIXPANEL_KEY PK_MIXPANEL_KEY_STAGING  
#else
#   define PK_PECK_SERVER PK_SERVER_QA
#   define PK_PECK_SERVER_API PK_SERVER_API_QA
#   define PK_PUB_NUB_PUB_KEY PK_PUB_NUB_PUB_KEY_QA
#   define PK_PUB_NUB_SUB_KEY PK_PUB_NUB_SUB_KEY_QA
#   define PK_MIXPANEL_KEY PK_MIXPANEL_KEY_QA
#endif
// end servers: ****************************************************************
//******************************************************************************



//******************************************************************************
// Begin trace defines ***********************************************************
#if defined(PK_LUMBERJACK)
#   if defined(DEBUG)
#       define PK_LOG(...) DDLogInfo(@"INFO: %@", [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_INFO(...) DDLogInfo(@"%s:%d ***** INFO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_TODO DDLogDebug(@"%s:%d TODO: Implement", __FUNCTION__, __LINE__);
#       define PK_LOG_TODO_TASK(...) DDLogDebug(@"%s:%d TODO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_DEBUG(...) DDLogDebug(@"%s:%d ***** DEBUG: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_WARNING(...) DDLogWarn(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_ERROR(...) DDLogError(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_CRITICAL(...) DDLogError(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); NSAssert(NO, @"Critical Error");
#       define PK_LOG_TRACE DDLogVerbose(@"%s:%d ***** TRACE", __FUNCTION__, __LINE__);
#       define PK_LOG_TEST(...) DDLogVerbose(@"%s:%d\n********************************************************* TESTING: %@ *********************************************************", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#   else
// We only want warnings and errors to appear in the console for release builds
#       define PK_LOG(...)
#       define PK_LOG_INFO(...)
#       define PK_LOG_TODO
#       define PK_LOG_TODO_TASK(...)
#       define PK_LOG_DEBUG(...)
#       define PK_LOG_WARNING(...) DDLogWarn(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_ERROR(...) DDLogError(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_CRITICAL(...) DDLogError(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_TRACE
#       define PK_LOG_TEST(...)
#   endif
#else 
#   if defined(DEBUG)
#       define PK_LOG(...) NSLog(@"INFO: %@", [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_INFO(...) NSLog(@"%s:%d ***** INFO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_TODO NSLog(@"%s:%d TODO: Implement", __FUNCTION__, __LINE__);
#       define PK_LOG_TODO_TASK(...) NSLog(@"%s:%d TODO: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_DEBUG(...) NSLog(@"%s:%d ***** DEBUG: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_WARNING(...) NSLog(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_ERROR(...) NSLog(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_CRITICAL(...) NSLog(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]); NSAssert(NO, @"Critical Error");
#       define PK_LOG_TRACE NSLog(@"%s:%d ***** TRACE", __FUNCTION__, __LINE__);
#       define PK_LOG_TEST(...) NSLog(@"%s:%d\n********************************************************* TESTING: %@ *********************************************************", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#   else
// We only want warnings and errors to appear in the console for release builds
#       define PK_LOG(...)
#       define PK_LOG_INFO(...)
#       define PK_LOG_TODO
#       define PK_LOG_TODO_TASK(...)
#       define PK_LOG_DEBUG(...)
#       define PK_LOG_WARNING(...) NSLog(@"%s:%d ***** WARNING: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_ERROR(...) NSLog(@"%s:%d ***** ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_CRITICAL(...) NSLog(@"%s:%d ***** CRITICAL ERROR: %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#       define PK_LOG_TRACE
#       define PK_LOG_TEST(...)
#   endif
#endif
// End trace defines ***************************************************************
//******************************************************************************



//******************************************************************************
// Begin size defines ***********************************************************
#define PK_TABLE_VIEW_CELL_USER_HEIGHT              64
#define PK_TABLE_VIEW_HEADER_HEIGHT                 44
// End size defines ***************************************************************
//******************************************************************************

#endif // PECK_DEFINES_H