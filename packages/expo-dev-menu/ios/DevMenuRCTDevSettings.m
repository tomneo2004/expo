// Copyright 2015-present 650 Industries. All rights reserved.

#import <EXDevMenu/DevMenuRCTDevSettings.h>

@implementation DevMenuRCTDevSettings

- (NSArray<NSString *> *)supportedEvents
{
  return [super supportedEvents];
}

- (BOOL)isHotLoadingAvailable
{
  return NO;
}

- (BOOL)isRemoteDebuggingAvailable
{
  return NO;
}

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

- (id)settingForKey:(NSString *)key
{
  return nil;
}

- (void)reload
{
}

- (void)reloadWithReason:(NSString *)reason
{
}

- (void)onFastRefresh
{
}

- (void)setHotLoadingEnabled:(BOOL)isHotLoadingEnabled
{
}

- (void)setIsDebuggingRemotely:(BOOL)isDebuggingRemotelyEnabled
{
}

- (void)setProfilingEnabled:(BOOL)isProfilingEnabled
{
}

- (void)toggleElementInspector
{
}

- (void)setupHotModuleReloadClientIfApplicableForURL:(NSURL *)bundleURL
{
}

- (void)addMenuItem:(NSString *)title
{
}

- (void)setIsShakeToShowDevMenuEnabled:(BOOL)enabled
{
  
}

- (void)_remoteDebugSettingDidChange
{
}

- (void)_synchronizeAllSettings
{
}

@end
