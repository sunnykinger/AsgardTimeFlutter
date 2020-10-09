#import "AsgardTimePlugin.h"
#if __has_include(<asgard_time/asgard_time-Swift.h>)
#import <asgard_time/asgard_time-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "asgard_time-Swift.h"
#endif

@implementation AsgardTimePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAsgardTimePlugin registerWithRegistrar:registrar];
}
@end
