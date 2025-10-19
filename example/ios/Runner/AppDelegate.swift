import UIKit
import Flutter
import deeplink_listener // 👈 important: import your plugin module

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - Universal Link
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
      if  DeeplinkListenerPlugin.handleUserActivity(userActivity) {
          return true
      }
      return false
    }
    // MARK: - Custom URL Schemes
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if DeeplinkListenerPlugin.handleOpenURL(url) {
          return true
        }
        return false
    }
}
