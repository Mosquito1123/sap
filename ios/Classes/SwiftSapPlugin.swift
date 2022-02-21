import Flutter
import UIKit
import Gigya

public class SwiftSapPlugin: NSObject, FlutterPlugin {
    static var registrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }
    
    public static func register<T: GigyaAccountProtocol>(accountSchema: T.Type) {
        guard let registrar = self.registrar else { return }
        let instance = SwiftSapPluginTyped(accountSchema: accountSchema)
        instance.register(with: registrar)
    }
}
