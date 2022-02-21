#import "SapPlugin.h"
#if __has_include(<sap/sap-Swift.h>)
#import <sap/sap-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sap-Swift.h"
#endif

@implementation SapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSapPlugin registerWithRegistrar:registrar];
}
@end
