#import "EXDevelopmentClientController+Private.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTDevMenu.h>
#import <React/RCTAsyncLocalStorage.h>
#import <React/RCTDevSettings.h>

#import "EXDevelopmentClientBundle.h"
#import "EXDevelopmentClientBundleSource.h"

#import <UIKit/UIKit.h>

#if RCT_DEV

// This is needed because RCTPerfMonitor does not declare a public interface that we can import.
@interface RCTPerfMonitor <NSObject>

- (void)show;
- (void)hide;

@end

#endif


// Uncomment the below and set it to a React Native bundler URL to develop the launcher JS
//#define DEV_LAUNCHER_URL "http://10.0.0.176:8090/index.bundle?platform=ios&dev=true&minify=false"

NSString *fakeLauncherBundleUrl = @"embedded://exdevelopmentclient/dummy";


@implementation EXDevelopmentClientController

+ (instancetype)sharedInstance
{
  static EXDevelopmentClientController *theController;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    if (!theController) {
      theController = [[EXDevelopmentClientController alloc] init];
    }
  });
  return theController;
}

- (instancetype)init {
  if (self = [super init]) {
    self.moduleRegistryAdapter = [[UMModuleRegistryAdapter alloc] initWithModuleRegistryProvider:[[UMModuleRegistryProvider alloc] init]];
  }
  return self;
}

- (NSArray<id<RCTBridgeModule>> *)extraModulesForBridge:(RCTBridge *)bridge
{
  NSArray<id<RCTBridgeModule>> *extraModules = [_moduleRegistryAdapter extraModulesForBridge:bridge];
  return [extraModules arrayByAddingObjectsFromArray:@[
    [[RCTDevMenu alloc] init],
    [[RCTAsyncLocalStorage alloc] init],
  ]];
}

#ifdef DEV_LAUNCHER_URL

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  // LAN url for developing launcher JS
  return [NSURL URLWithString:@(DEV_LAUNCHER_URL)];
}

#else

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [NSURL URLWithString:fakeLauncherBundleUrl];
}

- (void)loadSourceForBridge:(RCTBridge *)bridge withBlock:(RCTSourceLoadBlock)loadCallback
{
  NSData *data = [NSData dataWithBytesNoCopy:EXDevelopmentClientBundle
                                      length:EXDevelopmentClientBundleLength
                                freeWhenDone:NO];
  loadCallback(nil, EXDevelopmentClientBundleSourceCreate([NSURL URLWithString:fakeLauncherBundleUrl],
                                                          data,
                                                          EXDevelopmentClientBundleLength));
}

#endif

- (void)startWithWindow:(UIWindow *)window delegate:(id<EXDevelopmentClientControllerDelegate>)delegate launchOptions:(NSDictionary *)launchOptions
{
  _delegate = delegate;
  _launchOptions = launchOptions;
  _window = window;

  [self navigateToLauncher];
}

- (void)navigateToLauncher {
  [self cleanUp];
  
  _launcherBridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:_launchOptions];
  RCTDevSettings *devSettings = (RCTDevSettings *)[_launcherBridge moduleForName:@"DevSettings"];
  [devSettings setIsDebuggingRemotely:false];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:_launcherBridge
                                                   moduleName:@"main"
                                            initialProperties:nil];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  _window.rootViewController = rootViewController;

  [_window makeKeyAndVisible];
}

- (void)cleanUp
{
  if (_appBridge) {
    // We need to hide a performance monitor manually, otherwise, the user could summon multiple of them.
    RCTPerfMonitor *monitor = (RCTPerfMonitor *)[_appBridge moduleForName:@"PerfMonitor"];
    RCTDevSettings *devSettings = (RCTDevSettings *)[_appBridge moduleForName:@"DevSettings"];
    [monitor hide];
    devSettings.isPerfMonitorShown = false;
    
    [_appBridge invalidate];
  }
}

@end


