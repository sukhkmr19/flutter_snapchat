#import "SnapchatFlutterPlugin.h"
#import <snapchat_flutter_plugin/snapchat_flutter_plugin-Swift.h>

@implementation SnapchatFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSnapchatFlutterPlugin registerWithRegistrar:registrar];
}
@end
