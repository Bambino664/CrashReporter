/**
 * Name: CrashReporter
 * Type: iOS application
 * Desc: iOS app for viewing the details of a crash, determining the possible
 *       cause of said crash, and reporting this information to the developer(s)
 *       responsible.
 *
 * Author: Lance Fetters (aka. ashikase)
 * License: GPL v3 (See LICENSE file for details)
 */

#import <Foundation/Foundation.h>

extern NSString * const kCrashLogDirectoryForMobile;
extern NSString * const kCrashLogDirectoryForRoot;

@class CrashLog;

@interface CrashLogGroup : NSObject
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *logDirectory;
@property (nonatomic, readonly) NSArray *crashLogs;
+ (NSArray *)groupsForMobile;
+ (NSArray *)groupsForRoot;
+ (void)forgetGroups;
+ (instancetype)groupWithName:(NSString *)name logDirectory:(NSString *)logDirectory;
- (instancetype)initWithName:(NSString *)name logDirectory:(NSString *)logDirectory;
- (void)addCrashLog:(CrashLog *)crashLog;
- (BOOL)delete;
- (BOOL)deleteCrashLog:(CrashLog *)crashLog;
@end

/* vim: set ft=objc ff=unix sw=4 ts=4 tw=80 expandtab: */
