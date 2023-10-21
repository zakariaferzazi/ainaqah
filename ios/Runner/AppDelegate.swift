import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var productId = "";
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let idChannel = FlutterMethodChannel(name: "getIdChannel",binaryMessenger: controller.binaryMessenger)
    idChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if(call.method == "id" && self.productId != ""){
            print(self.productId);
            result(self.productId);
        }else {
            result("")
        }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
       
        _ = (urlComponents?.queryItems)! as [NSURLQueryItem]
        print(url)

        let newURL = URL(string: url.absoluteString)!
        self.productId = newURL.valueOf("id")!
        return false
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
